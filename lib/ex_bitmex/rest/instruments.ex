defmodule ExBitmex.Rest.Instruments do
  alias ExBitmex.Rest

  @type instrument :: ExBitmex.Instrument.t()

  def all() do
    "/instrument"
    |> Rest.HTTPClient.non_auth_get()
    |> parse_response()
  end

  defp parse_response({:ok, data, rate_limit}) when is_list(data) do
    instruments =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, i} -> i end)

    {:ok, instruments, rate_limit}
  end

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExBitmex.Instrument,
      transformations: [:snake_case]
    )
  end
end
