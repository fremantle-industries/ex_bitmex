defmodule ExBitmex.Rest.User.CommissionTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.Commission

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get account commission status" do
    use_cassette "rest/user/commission_ok" do
      assert {:ok, commission, _} = User.Commission.get(@credentials)
      assert Enum.any?(commission) == true
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.Commission.get(@credentials)
    end
  end
end
