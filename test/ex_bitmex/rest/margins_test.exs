defmodule ExBitmex.Rest.MarginsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.Margins

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".list returns a list of margins if currency is 'all'" do
    use_cassette "rest/margins/list_all_ok" do
      assert {:ok, margins, _} = ExBitmex.Rest.Margins.list(@credentials, %{currency: "all"})
      assert [%ExBitmex.Margin{} | _] = margins
    end
  end

  test ".list return just default currency if no have a currency parameter" do
    use_cassette "rest/margins/list_ok" do
      assert {:ok, margin, _} = ExBitmex.Rest.Margins.list(@credentials)
      assert %ExBitmex.Margin{} = margin
    end
  end
end
