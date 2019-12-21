defmodule ExBitmex.Rest.Position.IndexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.Position
  doctest ExBitmex.Rest.Position.Index

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get returns a list of positions" do
    use_cassette "rest/position/index_ok" do
      assert {:ok, positions, _} = Position.Index.get(@credentials)
      assert [%ExBitmex.Position{} | _] = positions
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = Position.Index.get(@credentials)
    end
  end
end
