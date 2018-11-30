defmodule ExBitmex.Credentials do
  @type t :: %ExBitmex.Credentials{
          api_key: String.t(),
          api_secret: String.t()
        }

  @enforce_keys [:api_key, :api_secret]
  defstruct [:api_key, :api_secret]
end
