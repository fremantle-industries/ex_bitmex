defmodule ExBitmex.RateLimit do
  @type t :: %ExBitmex.RateLimit{
          limit: pos_integer,
          remaining: pos_integer,
          reset: pos_integer
        }

  # @enforce_keys [:limit, :remaining, :reset]
  defstruct [:limit, :remaining, :reset]
end
