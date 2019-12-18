defmodule ExBitmex.Rest.Trade.Index do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t()
  @type params :: map
  @type trade :: ExBitmex.Trade.t()
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/trade"

  @spec get(params) ::
          {:ok, [trade], rate_limit} | Rest.HTTPClient.auth_error_response()
  def get(params \\ %{}) do
    @path
    |> Rest.HTTPClient.non_auth_get(params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    trades =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, p} -> p end)

    {:ok, trades, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.Trade,
      transformations: [:snake_case]
    )
  end
end
