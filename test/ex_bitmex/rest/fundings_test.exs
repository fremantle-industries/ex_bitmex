defmodule ExBitmex.Rest.FundingsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.Fundings

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".all returns an ok tuple with the fundings" do
    use_cassette "rest/fundings/all_ok" do
      {:ok, fundings, _} = ExBitmex.Rest.Fundings.all(%{symbol: "XBTUSD", start: 0, count: 50})
      assert Enum.count(fundings) == 50
      assert [%ExBitmex.Funding{} | _] = fundings
    end
  end
end
