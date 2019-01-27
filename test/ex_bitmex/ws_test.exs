defmodule WsWrapper do
  @moduledoc false

  require Logger
  use ExBitmex.Ws
end

defmodule ExBitmex.WsTest do
  use ExUnit.Case

  setup do
    {:ok, socket} = WsWrapper.start_link()
    {:ok, socket: socket}
  end

  describe "initial state" do
    test "get state", %{socket: socket} do
      assert :sys.get_state(socket) == %{
               auth_subscribe: [],
               heartbeat: 1,
               subscribe: ["orderBookL2:XBTUSD"]
             }
    end
  end
end
