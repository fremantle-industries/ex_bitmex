defmodule ExBitmex.ActiveInterval do
  alias __MODULE__

  @type t :: %ActiveInterval{
          intervals: [String.t()],
          symbols: [String.t()]
        }

  defstruct ~w(intervals symbols)a
end
