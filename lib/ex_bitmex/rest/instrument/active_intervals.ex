defmodule ExBitmex.Rest.Instrument.ActiveIntervals do
  alias ExBitmex.Rest

  @type params :: map
  @type active_interval :: ExBitmex.ActiveInterval.t()
  @type rate_limit :: ExBitmex.RateLimit.t()
  @type error_reason :: term

  @path "/instrument/activeIntervals"

  @spec get :: {:ok, [active_interval], rate_limit} | {:error, error_reason, rate_limit | nil}
  def get do
    @path
    |> Rest.HTTPClient.non_auth_get(%{})
    |> parse_response()
  end

  defp parse_response({:ok, data, rate_limit}) when is_map(data) do
    {:ok, active_interval} = data |> to_struct()
    {:ok, active_interval, rate_limit}
  end

  defp parse_response({:error, _, _} = error), do: error

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.ActiveInterval,
      transformations: [:snake_case]
    )
  end
end
