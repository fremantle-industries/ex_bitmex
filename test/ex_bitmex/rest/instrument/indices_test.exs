defmodule ExBitmex.Rest.Instrument.IndicesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Instrument
  doctest ExBitmex.Rest.Instrument.Indices

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns a list of instruments" do
    use_cassette "rest/instrument/indices_ok" do
      assert {:ok, instruments, _} = Instrument.Indices.get()
      assert Enum.any?(instruments) == true
      assert %ExBitmex.Instrument{} = instrument = instruments |> hd()
      assert instrument.turnover24h == nil
      assert instrument.taker_fee == nil
    end
  end

  test ".get bubbles errors without the rate limit" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Instrument.Indices.get()
    end
  end
end
