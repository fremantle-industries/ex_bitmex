defmodule ExBitmex.Rest.User.Show do
  alias ExBitmex.Rest

  @type credentials :: ExBitmex.Credentials.t() | nil
  @type user :: ExBitmex.User.t()
  @type rate_limit :: ExBitmex.RateLimit.t()

  @path "/user"

  def get(%ExBitmex.Credentials{} = credentials, params \\ %{}) do
    @path
    |> Rest.HTTPClient.auth_get(credentials, params)
    |> parse_response
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    margins =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, p} -> p end)

    {:ok, margins, rate_limit}
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, margin} = data |> to_struct
    {:ok, margin, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.User,
      transformations: [:snake_case]
    )
  end
end
