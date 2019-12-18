defmodule ExBitmex.Rest.User.Commission do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t() | nil
  @type params :: map
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/user/commission"

  def get(%ExBitmex.Credentials{} = credentials, params \\ %{}) do
    @path
    |> Rest.HTTPClient.auth_get(credentials, params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, data, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error
end
