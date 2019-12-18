defmodule ExBitmex.Rest.User.MarginTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.Margin

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get returns the default margin" do
    use_cassette "rest/user/margin_ok" do
      assert {:ok, margin, _} = User.Margin.get(@credentials)
      assert %ExBitmex.Margin{} = margin
    end
  end

  test ".get can return the margin for all currencies" do
    use_cassette "rest/user/margin_all_ok" do
      assert {:ok, margins, _} = User.Margin.get(@credentials, %{currency: "all"})
      assert [%ExBitmex.Margin{} | _] = margins
    end
  end

  test ".get bubbles errors without the rate limit" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.Margin.get(@credentials)
    end
  end
end
