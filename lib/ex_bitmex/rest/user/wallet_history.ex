defmodule ExBitmex.Rest.User.WalletHistory do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t()
  @type error_reason :: term
  @type wallet_history :: ExBitmex.WalletHistory.t()
  @type params :: map
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/user/walletHistory"

  @spec get(credentials, params) :: {:ok, [wallet_history], rate_limit} | {:error, error_reason, rate_limit | nil}
  def get(%ExBitmex.Credentials{} = credentials, params \\ %{}) do
    @path
    |> Rest.HTTPClient.auth_get(credentials, params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    history =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, p} -> p end)

    {:ok, history, rate_limit}
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, history} = data |> to_struct
    {:ok, history, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.WalletHistory,
      transformations: [:snake_case]
    )
  end
end
