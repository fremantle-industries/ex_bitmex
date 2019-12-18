defmodule ExBitmex.Rest.User.ShowTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.Show

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get returns the user model" do
    use_cassette "rest/user/show_ok" do
      assert {:ok, user, _} = User.Show.get(@credentials)
      assert %ExBitmex.User{} = user
      assert user.id != nil
      assert user.affiliate_id != nil
    end
  end

  test ".get bubbles errors without the rate limit" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.Show.get(@credentials)
    end
  end
end
