defmodule ExBitmex.Trade do
  @type t :: %ExBitmex.Trade{}

  defstruct ~w(
    foreign_notional
    gross_value
    home_notional
    price
    side
    size
    symbol
    tick_direction
    timestamp
    trd_match_id
  )a
end
