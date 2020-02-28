defmodule ExBitmex.Rest.HTTPClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.HTTPClient

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe ".auth_put" do
    test "returns an ok tuple with json" do
      use_cassette "rest/http_client/auth_put_ok" do
        assert {:ok, %{}, _} =
                 ExBitmex.Rest.HTTPClient.auth_put(
                   "/order",
                   @credentials,
                   %{orderID: "8d6f2649-7477-4db5-e32a-d8d5bf99dd9b", leavesQty: 2}
                 )
      end
    end
  end

  describe ".auth_delete" do
    test "returns an ok tuple with json" do
      use_cassette "rest/http_client/auth_delete_ok" do
        assert {:ok, [%{}], _} =
                 ExBitmex.Rest.HTTPClient.auth_delete(
                   "/order",
                   @credentials,
                   %{orderID: "39b0996e-72bf-1db1-0630-483375da71ec"}
                 )
      end
    end
  end

  describe ".auth_get" do
    test "returns an ok tuple with json" do
      use_cassette "rest/http_client/auth_get_ok" do
        assert {:ok, [_ | _], _} = ExBitmex.Rest.HTTPClient.auth_get("/order", @credentials, %{})
      end
    end
  end

  describe ".non_auth_get" do
    test "returns an ok tuple with json" do
      use_cassette "rest/http_client/non_auth_get_ok" do
        assert {:ok, [_ | _], _} = ExBitmex.Rest.HTTPClient.non_auth_get("/stats", %{})
      end
    end
  end
end
