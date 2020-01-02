defmodule ExBitmex.Rest.User.WalletHistoryTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  alias ExBitmex.Rest.User
  doctest ExBitmex.Rest.User.WalletHistory

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".get returns the wallet history information" do
    use_cassette "rest/user/wallet_history_ok" do
      assert {:ok, [%ExBitmex.WalletHistory{currency: "XBt"} | _tail], _} = User.WalletHistory.get(@credentials, %{symbol: "XBt", count: 10})
    end
  end

  test ".get bubbles errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert {:error, :timeout, nil} = User.WalletHistory.get(@credentials)
    end
  end
end
