defmodule ExBitmex.Rest.Instrument.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Instrument
  doctest ExBitmex.Rest.Instrument.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns a list of instruments" do
    use_cassette "rest/instrument/index_ok" do
      assert {:ok, instruments, _} = Instrument.Index.get()
      assert Enum.any?(instruments) == true
      assert %ExBitmex.Instrument{} = instrument = instruments |> hd()
      assert instrument.turnover24h != nil
      assert instrument.taker_fee != nil
    end
  end

  test ".get can use query params" do
    use_cassette "rest/instrument/index_with_params_ok" do
      assert {:ok, instruments, _} = Instrument.Index.get(%{start: 0, count: 1})
      assert Enum.count(instruments) == 1
    end
  end

  test ".get bubbles errors without the rate limit" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Instrument.Index.get(%{start: 0, count: 1})
    end
  end
end
