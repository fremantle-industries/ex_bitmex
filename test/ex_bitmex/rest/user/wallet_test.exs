defmodule ExBitmex.Rest.User.WalletTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.Wallet

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get returns the current wallet information" do
    use_cassette "rest/user/wallet_ok" do
      assert {:ok, wallet, _} = User.Wallet.get(@credentials)
      assert %ExBitmex.Wallet{} = wallet
      assert wallet.currency != nil
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.Wallet.get(@credentials)
    end
  end
end
