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
      %{
        auth_subscribe: [],
        name: WsWrapper,
        heartbeat: heartbeat,
        subscribe: ["orderBookL2:XBTUSD"]
      } = :sys.get_state(socket)

      assert heartbeat != nil
    end
  end
end
