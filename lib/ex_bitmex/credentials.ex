defmodule ExBitmex.Credentials do
  require Logger

  @type t :: %ExBitmex.Credentials{
          api_key: String.t(),
          api_secret: String.t()
        }

  @enforce_keys [:api_key, :api_secret]
  defstruct [:api_key, :api_secret]

  @doc """
  Default credentials

  ## Examples
      iex> ExBitmex.Credentials.config()
  """
  def config(nil) do
    %__MODULE__{
      api_key: System.get_env("BITMEX_API_KEY"),
      api_secret: System.get_env("BITMEX_API_SECRET")
    }
  end

  @doc """
  Fetch dynamic API credentials

  ## Examples
      iex> ExBitmex.Credentials.config(%{access_keys: ["B1_API_KEY", "B1_API_SECRET"]})
  """
  def config(%{
        access_keys: [api_key_access, api_secret_access]
      }) do
    %__MODULE__{
      api_key: System.get_env(api_key_access),
      api_secret: System.get_env(api_secret_access)
    }
  end

  def config(_) do
    Logger.error("Incorrect config setup.")
  end
end
