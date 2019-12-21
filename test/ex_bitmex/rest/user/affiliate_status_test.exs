defmodule ExBitmex.Rest.User.AffiliateStatusTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.AffiliateStatus

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get current affiliate/referral status" do
    use_cassette "rest/user/affiliate_status_ok" do
      assert {:ok, affiliate_status, _} = User.AffiliateStatus.get(@credentials)
      assert %ExBitmex.AffiliateStatus{} = affiliate_status
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.AffiliateStatus.get(@credentials)
    end
  end
end
