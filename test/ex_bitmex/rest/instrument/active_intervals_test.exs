defmodule ExBitmex.Rest.Instrument.ActiveIntervalsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Instrument
  doctest ExBitmex.Rest.Instrument.ActiveIntervals

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns a list of instruments" do
    use_cassette "rest/instrument/active_intervals_ok" do
      assert {:ok, active_interval, _} = Instrument.ActiveIntervals.get()
      assert %ExBitmex.ActiveInterval{} = active_interval
      assert Enum.any?(active_interval.intervals) == true
      assert Enum.any?(active_interval.symbols) == true
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Instrument.ActiveIntervals.get()
    end
  end
end
