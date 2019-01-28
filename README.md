# ExBitmex
[![CircleCI](https://circleci.com/gh/fremantle-capital/ex_bitmex.svg?style=svg)](https://circleci.com/gh/fremantle-capital/ex_bitmex)
[![Coverage Status](https://coveralls.io/repos/github/fremantle-capital/ex_bitmex/badge.svg?branch=master)](https://coveralls.io/github/fremantle-capital/ex_bitmex?branch=master)

Bitmex API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bitmex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_bitmex, "~> 0.0.5"}
  ]
end
```

Setup Bitmex, set `test_mode` to `true` in test environment. In production set to `false`

```elixir
config :bitmex, test_mode: false
```

## Static API Key

By default, this library will fetch the API key from the environment.

```elixir
api_key: System.get_env("BITMEX_API_KEY"),
api_secret: System.get_env("BITMEX_SECRET")
```

## Dynamic API Key

There will be cases when we want to switch to different API keys based on different info or need. That's why we're supporting this.

One of the use case when you want to have the dynamic API key feature is: when you want to using multiple API keys in the same app. In that case you simply need to spawn a process which encapsulate the config info. And each process with have it's own credentials to interact with Bitmex.

So we can tell either API or Websocket module to use certain access keys to retrieve the API keys that we want.

NOTE: The access key must be in string.

SECURITY: Access key is passed around instead of actual value of the key is to reduce the security risk. People can not inspect the key when the program up and running. This follow Tell, don't ask principle.

```elixir
ExBitmex.Credentials.config(%{access_keys: ["BITMEX1_API_KEY", "BITMEX1_API_SECRET"]})

# or

ExBitmex.Credentials.config(%{access_keys: ["BITMEX2_API_KEY", "BITMEX2_API_SECRET"]})
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bitmex](https://hexdocs.pm/bitmex).
