defmodule ExBitmex.CompositeIndex do
  alias __MODULE__

  @type t :: %CompositeIndex{
          timestamp: String.t(),
          symbol: String.t(),
          index_symbol: String.t(),
          reference: String.t(),
          last_price: non_neg_integer(),
          weight: non_neg_integer(),
          logged: String.t()
        }

  defstruct ~w(timestamp symbol index_symbol reference last_price weight logged)a
end
