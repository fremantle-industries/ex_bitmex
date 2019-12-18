defmodule ExBitmex.Rest.Position.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ExBitmex.Rest.Position
  doctest ExBitmex.Rest.Position.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_SECRET")
  }

  test ".get returns a list of positions" do
    use_cassette "rest/position/index_ok" do
      assert {:ok, positions, _} = Position.Index.get(@credentials)
      assert [%ExBitmex.Position{} | _] = positions
    end
  end
end
