defmodule ExBitmex.Rest.HTTPClient do
  @type verb :: :get | :post | :put | :delete
  @type credentials :: ExBitmex.Credentials.t()
  @type params :: map
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type bad_request :: {:bad_request, error :: map}
  @type forbidden :: {:forbidden, message :: String.t()}
  @type ip_forbidden :: :ip_forbidden
  @type invalid_signature :: :invalid_signature
  @type unauthorized :: {:unauthorized, message :: String.t()}
  @type auth_error_reason ::
          :timeout
          | :not_found
          | ip_forbidden
          | forbidden
          | invalid_signature
          | unauthorized
          | bad_request
  @type auth_response ::
          {:ok, map | [map], rate_limit} | {:error, auth_error_reason, rate_limit | nil}
  @type non_auth_error_reason ::
          :timeout
          | :not_found
          | bad_request
  @type non_auth_response ::
          {:ok, map | [map], rate_limit} | {:error, non_auth_error_reason, rate_limit | nil}

  @origin Application.get_env(:ex_bitmex, :origin, "https://www.bitmex.com")
  @api_path Application.get_env(:ex_bitmex, :api_path, "/api/v1")

  @spec auth_get(path :: String.t(), credentials, params) :: auth_response
  def auth_get(path, credentials, params) do
    auth_request(:get, path, credentials, params)
  end

  @spec auth_post(path :: String.t(), credentials, params) :: auth_response
  def auth_post(path, credentials, params) do
    auth_request(:post, path, credentials, params)
  end

  @spec auth_put(path :: String.t(), credentials, params) :: auth_response
  def auth_put(path, credentials, params) do
    auth_request(:put, path, credentials, params)
  end

  @spec auth_delete(path :: String.t(), credentials, params) :: auth_response
  def auth_delete(path, credentials, params) do
    auth_request(:delete, path, credentials, params)
  end

  @spec auth_request(verb, path :: String.t(), credentials, params) :: auth_response
  def auth_request(verb, path, credentials, params) do
    body = Jason.encode!(params)

    headers =
      verb
      |> auth_headers(path, body, credentials)
      |> put_content_type(:json)

    %HTTPoison.Request{
      method: verb,
      url: path |> url,
      headers: headers,
      body: body
    }
    |> send
  end

  @spec non_auth_get(path :: String.t(), params) :: non_auth_response
  def non_auth_get(path, params \\ %{}) do
    non_auth_request(:get, path, params)
  end

  @spec non_auth_request(verb, path :: String.t(), params) :: non_auth_response
  def non_auth_request(verb, path, params) do
    body = Jason.encode!(params)
    headers = [] |> put_content_type(:json)

    %HTTPoison.Request{
      method: verb,
      url: path |> url,
      headers: headers,
      body: body
    }
    |> send
  end

  @spec url(path :: String.t()) :: String.t()
  def url(path) do
    @origin <> @api_path <> path
  end

  defp send(request) do
    request
    |> HTTPoison.request()
    |> parse_rate_limits
    |> parse_response
  end

  defp auth_headers(verb, path, data, credentials) do
    nonce = ExBitmex.Auth.nonce()
    normalized_verb = verb |> normalize_verb

    signature =
      ExBitmex.Auth.sign(
        credentials.api_secret,
        normalized_verb,
        @api_path <> path,
        nonce,
        data
      )

    [
      "api-nonce": nonce |> to_string(),
      "api-key": credentials.api_key,
      "api-signature": signature
    ]
  end

  defp normalize_verb(:get), do: "GET"
  defp normalize_verb(:post), do: "POST"
  defp normalize_verb(:put), do: "PUT"
  defp normalize_verb(:delete), do: "DELETE"

  defp put_content_type(headers, :json) do
    Keyword.put(headers, :"Content-Type", "application/json")
  end

  @limit_header "X-RateLimit-Limit"
  @remaining_header "X-RateLimit-Remaining"
  @reset_header "X-RateLimit-Reset"

  defp parse_rate_limits({result, %HTTPoison.Response{headers: headers} = response}) do
    limit_headers =
      headers
      |> Enum.reduce(
        %{},
        fn {k, v}, acc ->
          case k do
            @limit_header -> Map.put(acc, :limit, v)
            @remaining_header -> Map.put(acc, :remaining, v)
            @reset_header -> Map.put(acc, :reset, v)
            _ -> acc
          end
        end
      )

    rate_limit = limit_headers |> build_rate_limit
    {result, response, rate_limit}
  end

  defp parse_rate_limits({result, %HTTPoison.Error{} = error}) do
    {result, error, nil}
  end

  defp build_rate_limit(%{limit: limit, remaining: remaining, reset: reset}) do
    %ExBitmex.RateLimit{
      limit: limit |> String.to_integer(),
      remaining: remaining |> String.to_integer(),
      reset: reset |> String.to_integer()
    }
  end

  defp build_rate_limit(%{}), do: nil

  defp parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}, rate_limit}) do
    json = body |> Jason.decode!()
    {:ok, json, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 400, body: body}, rate_limit}) do
    json = body |> Jason.decode!()
    reason = {:bad_request, json}
    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 401, body: body}, rate_limit}) do
    message =
      body
      |> Jason.decode!()
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message == "Signature not valid." do
        :invalid_signature
      else
        {:unauthorized, message}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 403, body: body}, rate_limit}) do
    message =
      body
      |> Jason.decode!()
      |> Map.fetch!("error")
      |> Map.fetch!("message")

    reason =
      if message == "This IP address is not allowed to use this key." do
        :ip_forbidden
      else
        {:forbidden, message}
      end

    {:error, reason, rate_limit}
  end

  defp parse_response({:ok, %HTTPoison.Response{status_code: 404}, rate_limit}) do
    {:error, :not_found, rate_limit}
  end

  defp parse_response({:error, %HTTPoison.Error{reason: "timeout"}, rate_limit}) do
    {:error, :timeout, rate_limit}
  end
end
