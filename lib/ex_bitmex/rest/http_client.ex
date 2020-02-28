defmodule ExBitmex.Rest.HTTPClient do
  alias ExBitmex.Rest.Request

  @type path :: Request.path()
  @type credentials :: Request.credentials()
  @type params :: Request.params()
  @type auth_response :: Request.auth_response()
  @type non_auth_response :: Request.non_auth_response()

  @spec auth_get(path, credentials, params) :: auth_response
  def auth_get(path, credentials, params) do
    Request.auth_request(:get, path, credentials, params)
  end

  @spec auth_post(path, credentials, params) :: auth_response
  def auth_post(path, credentials, params) do
    Request.auth_request(:post, path, credentials, params)
  end

  @spec auth_put(path, credentials, params) :: auth_response
  def auth_put(path, credentials, params) do
    Request.auth_request(:put, path, credentials, params)
  end

  @spec auth_delete(path, credentials, params) :: auth_response
  def auth_delete(path, credentials, params) do
    Request.auth_request(:delete, path, credentials, params)
  end

  @spec non_auth_get(path, params) :: non_auth_response
  def non_auth_get(path, params \\ %{}) do
    Request.non_auth_request(:get, path, params)
  end
end
