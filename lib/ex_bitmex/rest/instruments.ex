defmodule ExBitmex.Rest.Instruments do
  alias ExBitmex.Rest

  def all do
    "/instrument"
    |> Rest.HTTPClient.non_auth_get()
  end
end
