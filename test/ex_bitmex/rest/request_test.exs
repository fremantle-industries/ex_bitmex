defmodule ExBitmex.Rest.RequestTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock
  doctest ExBitmex.Rest.Request

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  setup_all do
    HTTPoison.start()
    :ok
  end

  describe ".send/1 success" do
    test "returns the body payload as json" do
      use_cassette "rest/request/ok_payload_json" do
        assert {:ok, [_ | _], _} = ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})
      end
    end

    test "returns rate limit for successful requests" do
      use_cassette "rest/request/ok_with_rate_limit" do
        assert {:ok, _, rate_limit} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})

        assert %ExBitmex.RateLimit{} = rate_limit
        assert rate_limit.limit > 0
        assert rate_limit.remaining > 0
        assert rate_limit.reset > 0
      end
    end
  end

  describe ".send/1 error" do
    test "returns an error when rate limited" do
      use_cassette "rest/request/error_rate_limited" do
        assert {:error, :rate_limited, rate_limit} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})

        assert %ExBitmex.RateLimit{} = rate_limit
        assert rate_limit.limit > 0
        assert rate_limit.remaining == 0
        assert rate_limit.reset > 0
      end
    end

    test "returns an error without rate limits when the request times out" do
      with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
        assert ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{}) ==
                 {:error, :timeout, nil}
      end
    end

    test "returns an error without rate limits when the request has a connect timeout" do
      with_mock HTTPoison,
        request: fn _url -> {:error, %HTTPoison.Error{reason: :connect_timeout}} end do
        assert ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{}) ==
                 {:error, :connect_timeout, nil}
      end
    end

    test "returns an error without rate limits when the IP address is forbidden" do
      use_cassette "rest/request/error_ip_forbidden" do
        assert {:error, :ip_forbidden, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})
      end
    end

    test "returns an error without rate limits when the signature is invalid" do
      use_cassette "rest/request/error_invalid_signature" do
        assert {:error, :invalid_signature, nil} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})
      end
    end

    test "returns an error when the params are invalid" do
      use_cassette "rest/request/error_bad_request" do
        assert {:error, reason, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(:post, "/order", @credentials, %{})

        assert {:bad_request, msg} = reason

        assert msg ==
                 %{
                   "error" => %{
                     "message" => "'symbol' is a required arg.",
                     "name" => "HTTPError"
                   }
                 }
      end
    end

    test "returns an error when a resource is not found" do
      use_cassette "rest/request/error_not_found" do
        assert {:error, :not_found, _} =
                 ExBitmex.Rest.HTTPClient.auth_request(
                   :delete,
                   "/stats",
                   @credentials,
                   %{orderID: "a9b0996e-72bf-1db1-0630-483375da71ec"}
                 )
      end
    end

    test "returns an error when overloaded" do
      use_cassette "rest/request/error_overloaded" do
        assert {:error, :overloaded, _} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})
      end
    end

    test "returns an error when the nonce is not increasing" do
      use_cassette "rest/request/error_nonce_not_increasing" do
        assert {:error, {:nonce_not_increasing, msg}, _} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})

        assert msg =~ "Nonce is not increasing. This nonce:"
      end
    end

    test "returns an error when the response is a bad gateway" do
      use_cassette "rest/request/error_bad_gateway" do
        assert {:error, :bad_gateway, _} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})
      end
    end

    test "returns an error when a connection to the domain can't be established" do
      use_cassette "rest/request/error_no_connection" do
        assert {:error, :non_existent_domain, nil} =
                 ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{})
      end

      with_mock HTTPoison,
        request: fn _url -> {:error, %HTTPoison.Error{reason: :nxdomain}} end do
        assert ExBitmex.Rest.HTTPClient.non_auth_request(:get, "/stats", %{}) ==
                 {:error, :non_existent_domain, nil}
      end
    end
  end
end
