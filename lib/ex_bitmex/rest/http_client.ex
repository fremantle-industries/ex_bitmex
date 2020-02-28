defmodule ExBitmex.Rest.HTTPClient do
  alias ExBitmex.Rest.Request

  @type verb :: :get | :post | :put | :delete
  @type path :: Request.path()
  @type credentials :: Request.credentials()
  @type params :: Request.params()
  @type auth_response :: Request.auth_response()
  @type non_auth_response :: Request.non_auth_response()

  @spec auth_get(path, credentials, params) :: auth_response
  def auth_get(path, credentials, params) do
    auth_request(:get, path, credentials, params)
  end

  @spec auth_post(path, credentials, params) :: auth_response
  def auth_post(path, credentials, params) do
    auth_request(:post, path, credentials, params)
  end

  @spec auth_put(path, credentials, params) :: auth_response
  def auth_put(path, credentials, params) do
    auth_request(:put, path, credentials, params)
  end

  @spec auth_delete(path, credentials, params) :: auth_response
  def auth_delete(path, credentials, params) do
    auth_request(:delete, path, credentials, params)
  end

  @spec non_auth_get(path, params) :: non_auth_response
  def non_auth_get(path, params \\ %{}) do
    non_auth_request(:get, path, params)
  end

  @spec auth_request(verb, path, credentials, params) :: auth_response
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
    |> Request.send()
  end

  @spec non_auth_request(verb, path, params) :: non_auth_response
  def non_auth_request(verb, path, params) do
    body = Jason.encode!(params)
    headers = [] |> put_content_type(:json)

    %HTTPoison.Request{
      method: verb,
      url: path |> url,
      headers: headers,
      body: body
    }
    |> Request.send()
  end

  def rest_protocol, do: Application.get_env(:ex_bitmex, :rest_protocol, "https://")

  def domain, do: Application.get_env(:ex_bitmex, :domain, "www.bitmex.com")

  def origin, do: rest_protocol() <> domain()

  def api_path, do: Application.get_env(:ex_bitmex, :api_path, "/api/v1")

  @spec url(path) :: String.t()
  def url(path), do: origin() <> api_path() <> path

  defp auth_headers(verb, path, data, credentials) do
    nonce = ExBitmex.Auth.nonce()
    normalized_verb = verb |> normalize_verb

    signature =
      ExBitmex.Auth.sign(
        credentials.api_secret,
        normalized_verb,
        api_path() <> path,
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
end
