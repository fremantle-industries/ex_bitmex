defmodule ExBitmex.Rest.Instrument.CompositeIndex do
  alias ExBitmex.Rest

  @type params :: map
  @type composite_index :: ExBitmex.CompositeIndex.t()
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type error_reason :: term

  @path "/instrument/compositeIndex"

  @spec get(String.t(), map) ::
          {:ok, [composite_index], rate_limit} | {:error, error_reason, rate_limit | nil}
  def get(symbol, params \\ %{}) do
    params = Map.put(params, :symbol, symbol)

    @path
    |> Rest.HTTPClient.non_auth_get(params)
    |> parse_response()
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    composite_indexes =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, composite_indexes, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.CompositeIndex,
      transformations: [:snake_case]
    )
  end
end
