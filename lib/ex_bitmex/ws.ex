defmodule ExBitmex.Ws do
  @moduledoc """
  BitMEX WebSocket client.
  """

  import Process, only: [send_after: 3]

  defmacro __using__(_opts) do
    quote do
      use WebSockex
      require Logger

      ## API

      def start_link(args \\ %{}) do
        subscription = args[:subscribe] || ["orderBookL2:XBTUSD"]
        auth_subscription = args[:auth_subscribe] || []
        name = args[:name] || __MODULE__

        state =
          Map.merge(args, %{
            subscribe: subscription,
            auth_subscribe: auth_subscription,
            heartbeat: 0,
            name: name
          })

        WebSockex.start_link(base_uri(), __MODULE__, state, name: name)
      end

      ## WebSocket Callbacks

      @impl true
      def handle_connect(_conn, %{name: name} = state) do
        Logger.info("#{name} connected")
        send(self(), :ws_subscribe)
        {:ok, state}
      end

      @impl true
      def handle_disconnect(disconnect_map, state) do
        Logger.warn("#{__MODULE__} disconnected: #{inspect(disconnect_map)}")
        {:reconnect, state}
      end

      @impl true
      def handle_pong(:pong, state) do
        {:ok, inc_heartbeat(state)}
      end

      @impl true
      def handle_frame({:text, text}, state) do
        case Jason.decode(text) do
          {:ok, %{"request" => %{"op" => "authKey"}, "success" => true} = payload} ->
            subscribe(self(), state[:auth_subscribe])
            handle_response(payload, state)

          {:ok, payload} ->
            handle_response(payload, state)
        end

        {:ok, inc_heartbeat(state)}
      end

      @impl true
      def handle_frame(msg, %{name: name} = state) do
        Logger.warn("#{name} received unexpected WebSocket response: " <> inspect(msg))
        {:ok, state}
      end

      ## OTP Callbacks

      @impl true
      def handle_cast(_msg, state) do
        {:ok, state}
      end

      @impl true
      def handle_info(
            :ws_subscribe,
            %{subscribe: subscription, auth_subscribe: auth_subscription} = state
          ) do
        if match?([_ | _], subscription) do
          subscribe(self(), subscription)
        end

        if match?([_ | _], auth_subscription) do
          authenticate(self(), Map.get(state, :config))
        end

        send_after(self(), {:heartbeat, :ping, 1}, 20_000)
        {:ok, state}
      end

      @impl true
      def handle_info(
            {:heartbeat, :ping, expected_heartbeat},
            %{heartbeat: heartbeat} = state
          ) do
        if heartbeat >= expected_heartbeat do
          send_after(self(), {:heartbeat, :ping, heartbeat + 1}, 1_000)
          {:ok, state}
        else
          if not test_mode() do
            Logger.warn(
              "#{__MODULE__} sent heartbeat ##{heartbeat} " <> "due to low connectivity"
            )
          end

          send_after(self(), {:heartbeat, :pong, heartbeat + 1}, 4_000)
          {:reply, :ping, state}
        end
      end

      @impl true
      def handle_info(
            {:heartbeat, :pong, expected_heartbeat},
            %{heartbeat: heartbeat} = state
          ) do
        if heartbeat >= expected_heartbeat do
          send_after(self(), {:heartbeat, :ping, heartbeat + 1}, 1_000)
          {:ok, state}
        else
          Logger.warn("#{__MODULE__} terminated due to " <> "no heartbeat ##{heartbeat}")
          {:close, state}
        end
      end

      @impl true
      def handle_info({:ws_reply, frame}, state) do
        {:reply, frame, state}
      end

      @impl true
      def handle_info(error, state) do
        output_error(error, state, "received unexpected message")
        {:ok, state}
      end

      @impl true
      def terminate(info, %{name: name} = _state) do
        Logger.error("#{name} terminated - #{inspect(info)} ")
      end

      ## Helpers

      def reply_op(server, op, args) do
        json = Jason.encode!(%{op: op, args: args})
        send(server, {:ws_reply, {:text, json}})
      end

      def subscribe(server, channels) do
        reply_op(server, "subscribe", channels)
      end

      def authenticate(server, config) do
        nonce = ExBitmex.Auth.nonce()
        %{api_key: api_key, api_secret: api_secret} = ExBitmex.Credentials.config(config)

        if is_nil(api_key) || is_nil(api_secret) do
          Logger.error("Missing Bitmex API credentials")
          send(server, :terminate)
        else
          sig = ExBitmex.Auth.sign(api_secret, "GET", "/realtime", nonce, "")
          reply_op(server, "authKey", [api_key, nonce, sig])
        end
      end

      def handle_response(resp, _state) do
        Logger.debug("#{__MODULE__} received response: #{inspect(resp)}")
      end

      defp inc_heartbeat(%{heartbeat: heartbeat} = state) do
        Map.put(state, :heartbeat, heartbeat + 1)
      end

      defp output_error(error, state, msg) do
        Logger.error("#{__MODULE__} #{msg}: #{inspect(error)}" <> "\nstate: #{inspect(state)}")
      end

      defp test_mode do
        Application.get_env(:ex_bitmex, :test_mode)
      end

      defp base_uri do
        "wss://" <> ((test_mode() && "testnet") || "www") <> ".bitmex.com/realtime"
      end

      defoverridable handle_response: 2, handle_disconnect: 2
    end
  end
end
