# ExBitmex
![](https://github.com/fremantle-capital/ex_bitmex/workflows/.github/workflows/test.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/fremantle-capital/ex_bitmex/badge.svg?branch=master)](https://coveralls.io/github/fremantle-capital/ex_bitmex?branch=master)

BitMEX API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bitmex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_bitmex, "~> 0.3"}
  ]
end
```

## Usage

```elixir
# Public
{:ok, instruments, rate_limit} = ExBitmex.Rest.Instrument.Index.get(start: 0, count: 20)

# Private
credentials = %ExBitmex.Credentials{
  api_key: System.get_env("BITMEX_API_KEY"),
  api_secret: System.get_env("BITMEX_SECRET")
}

{:ok, positions, rate_limit} = ExBitmex.Rest.Position.Index.get(credentials)
```

## WebSocket

Create a WebSocket wrapper with a handler

```elixir
defmodule BitMexWebSocketWrapper do
  use ExBitmex.WebSocket

  def handle_response(json, _state) do
    Logger.warn("Received #{inspect(json)}")
  end
end
```
