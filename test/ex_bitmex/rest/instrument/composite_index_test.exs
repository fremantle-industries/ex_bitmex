defmodule ExBitmex.Rest.Instrument.CompositeIndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Instrument
  doctest ExBitmex.Rest.Instrument.CompositeIndex

  setup_all do
    HTTPoison.start()
    :ok
  end

  test ".get returns a list of instruments" do
    use_cassette "rest/instrument/composite_index_ok" do
      assert {:ok, composite_indexes, _} = Instrument.CompositeIndex.get(".XBT")
      assert Enum.any?(composite_indexes) == true
      assert %ExBitmex.CompositeIndex{} = composite_index = composite_indexes |> hd()
      assert composite_index.index_symbol != nil
    end
  end

  test ".get can use query params" do
    use_cassette "rest/instrument/composite_index_with_params_ok" do
      assert {:ok, instruments, _} = Instrument.CompositeIndex.get(".XBT", %{start: 0, count: 1})
      assert Enum.count(instruments) == 1
    end
  end

  test ".get bubbles errors without the rate limit" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Instrument.CompositeIndex.get(".XBT")
    end
  end
end
