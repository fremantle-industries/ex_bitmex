defmodule ExBitmex.Rest.Trade.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBitmex.Rest.Trade
  doctest ExBitmex.Rest.Trade.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".all returns an ok tuple with the trades" do
    use_cassette "rest/trades/all_ok" do
      {:ok, trades, _} = Trade.Index.get(%{symbol: "XBTUSD", start: 0, count: 50})
      assert Enum.count(trades) == 50
      assert [%ExBitmex.Trade{} | _] = trades
    end
  end
end
