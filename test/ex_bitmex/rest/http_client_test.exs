defmodule ExBitmex.Rest.HTTPClientTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExBitmex.Rest.HTTPClient

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: "api_key",
    api_secret: "api_secret"
  }

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
    :ok
  end

  describe ".auth_request" do
    test "returns the current rate limit" do
      use_cassette "rest/http_client/auth_request_rate_limit" do
        assert {:ok, _, rate_limit} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})

        assert rate_limit == %ExBitmex.RateLimit{
                 limit: 300,
                 remaining: 299,
                 reset: 1_543_383_854
               }
      end
    end

    test "returns an error tuple when the params are invalid" do
      use_cassette "rest/http_client/auth_request_error_bad_request" do
        assert {:error, reason, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})

        assert reason ==
                 {:bad_request,
                  %{
                    "error" => %{
                      "message" => "'symbol' is a required arg.",
                      "name" => "HTTPError"
                    }
                  }}
      end
    end

    test "returns an error tuple with no rate limits when the IP address is forbidden" do
      use_cassette "rest/http_client/auth_request_error_ip_forbidden" do
        assert {:error, :ip_forbidden, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})
      end
    end

    test "returns an error tuple with no rate limits when the signature is invalid" do
      use_cassette "rest/http_client/auth_request_error_invalid_signature" do
        assert {:error, :invalid_signature, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})
      end
    end

    test "returns an error tuple with no rate limits when the request times out" do
      use_cassette "rest/http_client/auth_request_error_timeout" do
        assert {:error, :timeout, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:get, "/stats", @credentials, %{})
      end
    end

    test "returns an error tuple when the resource is not found" do
      use_cassette "rest/http_client/auth_request_not_found" do
        assert {:error, :not_found, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(
                   :delete,
                   "/stats",
                   @credentials,
                   %{orderID: "a9b0996e-72bf-1db1-0630-483375da71ec"}
                 )
      end
    end

    test "returns an error tuple when overloaded" do
      use_cassette "rest/http_client/auth_request_overloaded" do
        assert {:error, :overloaded, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(:get, "/stats", @credentials, %{})
      end
    end

    test "returns an error tuple for 502 status code response" do
      use_cassette "rest/http_client/auth_request_error_502_bad_gateway", custom: true do
        assert {:error, {:service_unavailable, message}, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:put, "/order/bulk", @credentials, %{})

        assert message =~ "502 Bad Gateway"
      end
    end

    test "returns an error tuple for 403 status code response with html body" do
      use_cassette "rest/http_client/auth_request_error_403_forbidden", custom: true do
        assert {:error, :banned, nil} =
          ExBitmex.Rest.HTTPClient.auth_request(:put, "/order/bulk", @credentials, %{})
      end
    end

    test "returns an error tuple when the nonce is not increasing" do
      use_cassette "rest/http_client/auth_request_nonce_not_increasing" do
        assert {:error, {:nonce_not_increasing, msg}, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(:get, "/stats", @credentials, %{})

        assert msg ==
                 "Nonce is not increasing. This nonce: 62279790258940, last nonce: 62279790258995"
      end
    end
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

    test "handles rate limit error" do
      use_cassette "rest/http_client/auth_request_error_exceeded_rate_limit", custom: true do
        assert {:error, :exceeded_rate_limit, rate_limit} =
                 ExBitmex.Rest.HTTPClient.auth_put("/order/bulk", @credentials, %{})

        assert rate_limit == %ExBitmex.RateLimit{
                 limit: 300,
                 remaining: 0,
                 reset: 1_549_446_743
               }
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

  describe ".non_auth_request" do
    test "returns an ok tuple with json" do
      use_cassette "rest/http_client/non_auth_request_ok" do
        assert {:ok, [_ | _], _} = ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})
      end
    end

    test "returns the current rate limit" do
      use_cassette "rest/http_client/non_auth_request_rate_limit" do
        assert {:ok, _, rate_limit} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})

        assert rate_limit == %ExBitmex.RateLimit{
                 limit: 150,
                 remaining: 149,
                 reset: 1_543_467_798
               }
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
