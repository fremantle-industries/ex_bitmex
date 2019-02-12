defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExBitmex.Ws
end

defmodule ExBitmex.WsTest do
  use ExUnit.Case

  setup do
    {:ok, socket} = start_supervised({WsWrapper, %{}})
    {:ok, socket: socket}
  end

  describe "initial state" do
    test "get state", %{socket: socket} do
      assert %{
               auth_subscribe: [],
               name: WsWrapper,
               heartbeat: heartbeat,
               subscribe: ["orderBookL2:XBTUSD"]
             } = :sys.get_state(socket)

      assert heartbeat != nil
    end

    test "adds trace option if it presented in args" do
      {:ok, pid} = WsWrapper.start_link(%{trace: true, name: :ws})

      assert %{
               debug: [:trace]
             } = :sys.get_state(pid)
    end
  end
end
