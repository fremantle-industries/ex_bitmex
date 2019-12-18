defmodule ExBitmex.Rest.User.Wallet do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t() | nil
  @type wallet :: ExBitmex.Wallet.t()
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/user/wallet"

  def get(%ExBitmex.Credentials{} = credentials, params \\ %{}) do
    @path
    |> Rest.HTTPClient.auth_get(credentials, params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, margin} = data |> to_struct
    {:ok, margin, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.Wallet,
      transformations: [:snake_case]
    )
  end
end
