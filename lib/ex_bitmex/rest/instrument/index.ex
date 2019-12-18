defmodule ExBitmex.Rest.Instrument.Index do
  alias ExBitmex.Rest

  @type params :: map
  @type instrument :: ExBitmex.Instrument.t()
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type error_reason :: term

  @path "/instrument"

  @spec get(params) :: {:ok, [instrument], rate_limit} | {:error, error_reason, rate_limit | nil}
  def get(params \\ %{}) do
    @path
    |> Rest.HTTPClient.non_auth_get(params)
    |> parse_response()
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    instruments =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, instruments, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.Instrument,
      transformations: [:snake_case]
    )
  end
end
