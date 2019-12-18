defmodule ExBitmex.Rest.User.AffiliateStatus do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t() | nil
  @type params :: map
  @type affiliate_status :: ExBitmex.AffiliateStatus.t()
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/user/affiliateStatus"

  def get(%ExBitmex.Credentials{} = credentials, params \\ %{}) do
    @path
    |> Rest.HTTPClient.auth_get(credentials, params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, affiliate_status} = data |> to_struct
    {:ok, affiliate_status, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.AffiliateStatus,
      transformations: [:snake_case]
    )
  end
end
