defmodule ExBitmex.Rest.InstrumentsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.Instruments

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".all returns a list of instruments" do
    use_cassette "rest/instruments/all_ok" do
      assert {:ok, [%{"takerFee" => _} | _], _} = ExBitmex.Rest.Instruments.all()
    end
  end

  test "return an instrument details" do
    use_cassette "rest/instruments/get_mark_price" do
      assert {:ok, [%{"markPrice" => 10379.25} | _], _} = ExBitmex.Rest.Instruments.get_mark_price("XBTUSD")
    end
  end
end
