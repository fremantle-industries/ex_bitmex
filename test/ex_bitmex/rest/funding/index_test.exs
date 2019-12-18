defmodule ExBitmex.Rest.Funding.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.Funding.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns funding history" do
    use_cassette "rest/funding/index_ok" do
      {:ok, fundings, _} =
        ExBitmex.Rest.Funding.Index.get(%{symbol: "XBTUSD", start: 0, count: 50})

      assert Enum.count(fundings) == 50
      assert [%ExBitmex.Funding{} | _] = fundings
    end
  end
end
