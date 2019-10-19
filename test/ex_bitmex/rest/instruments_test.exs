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
      assert {:ok, instruments, _} = ExBitmex.Rest.Instruments.all()
      assert Enum.any?(instruments) == true
      assert %ExBitmex.Instrument{} = instrument = instruments |> hd()
      assert instrument.turnover24h != nil
      assert instrument.taker_fee != nil
    end
  end

  test ".all can use query params" do
    use_cassette "rest/instruments/all_with_params_ok" do
      assert {:ok, instruments, _} = ExBitmex.Rest.Instruments.all(%{start: 0, count: 1})
      assert Enum.count(instruments) == 1
    end
  end
end
