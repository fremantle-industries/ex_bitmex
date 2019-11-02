# ExBitmex
[![CircleCI](https://circleci.com/gh/fremantle-capital/ex_bitmex.svg?style=svg)](https://circleci.com/gh/fremantle-capital/ex_bitmex)
[![Coverage Status](https://coveralls.io/repos/github/fremantle-capital/ex_bitmex/badge.svg?branch=master)](https://coveralls.io/github/fremantle-capital/ex_bitmex?branch=master)

BitMEX API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bitmex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_bitmex, "~> 0.2"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bitmex](https://hexdocs.pm/bitmex).

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
