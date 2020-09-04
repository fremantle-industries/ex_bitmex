defmodule ExBitmex.Rest.Instruments do
  alias ExBitmex.Rest

  def all do
    "/instrument"
    |> Rest.HTTPClient.non_auth_get()
  end

  def get_mark_price(instrument) do
    Rest.HTTPClient.non_auth_get("/instrument", %{symbol: instrument})
  end
end
