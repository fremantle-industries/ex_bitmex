defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExBitmex.Ws
end

defmodule ExBitmex.WsTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  setup do
    {:ok, socket} = WsWrapper.start_link()
    {:ok, socket: socket}
  end

  describe "initial state" do
    test "get state", %{socket: socket} do
      %{
        auth_subscribe: [],
        name: WsWrapper,
        heartbeat: heartbeat,
        subscribe: ["orderBookL2:XBTUSD"]
      } = :sys.get_state(socket)

      assert heartbeat != nil
    end
  end

  describe "heartbeat logic" do
    test "returns input state when heartbeat >= expected heartbeat", %{socket: socket} do
      %{heartbeat: heartbeat} = state = :sys.get_state(socket)
      message = {:heartbeat, :ping, heartbeat - 1}

      assert {:ok, ^state} = WsWrapper.handle_info(message, state)
    end

    test "returns reply tuple when heartbeat < expected heartbeat", %{socket: socket} do
      %{heartbeat: heartbeat} = state = :sys.get_state(socket)
      message = {:heartbeat, :ping, heartbeat + 1}

      assert {:reply, :ping, state} = WsWrapper.handle_info(message, state)
    end

    test "logs low connectivity when heartbeat < expected heartbeat", %{socket: socket} do
      %{heartbeat: heartbeat} = state = :sys.get_state(socket)
      message = {:heartbeat, :ping, heartbeat + 1}

      assert capture_log(fn -> WsWrapper.handle_info(message, state) end) =~ "low connectivity"
    end
  end
end
