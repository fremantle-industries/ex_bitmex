defmodule ExBitmex.Rest.Trade.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Trade
  doctest ExBitmex.Rest.Trade.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns an ok tuple with the trades" do
    use_cassette "rest/trade/index_ok" do
      {:ok, trades, _} = Trade.Index.get(%{symbol: "XBTUSD", start: 0, count: 50})
      assert Enum.count(trades) == 50
      assert [%ExBitmex.Trade{} | _] = trades
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Trade.Index.get()
    end
  end
end
