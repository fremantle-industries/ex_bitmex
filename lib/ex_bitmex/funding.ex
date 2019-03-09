defmodule ExBitmex.Funding do
  @type t :: %ExBitmex.Funding{}

  defstruct ~w(funding_interval funding_rate funding_rate_daily symbol timestamp)a
end
