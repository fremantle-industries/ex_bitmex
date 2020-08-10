defmodule ExBitmex.Rest.PositionsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.Positions

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".all returns a list of positions" do
    use_cassette "rest/positions/all_ok" do
      assert {:ok, positions, _} = ExBitmex.Rest.Positions.all(@credentials)
      assert [%ExBitmex.Position{} | _] = positions
    end
  end
end
