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
  api_secret: System.get_env("BITMEX_API_SECRET")
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

## REST Status

#### Announcement

- [ ] `GET /announcement`
- [ ] `GET /announcement/urgent`

#### APIKey

- [ ] `GET /apiKey`

#### Chat

- [ ] `GET /chat`
- [ ] `POST /chat`
- [ ] `GET /chat/channels`
- [ ] `GET /chat/connected`

#### Execution

- [ ] `GET /execution`
- [ ] `GET /execution/tradeHistory`

#### Funding

- [x] `GET /funding`

#### GlobalNotification

- [ ] `GET /globalNotification`

#### Instrument

- [x] `GET /instrument`
- [x] `GET /instrument/active`
- [x] `GET /instrument/activeAndIndices`
- [x] `GET /instrument/activeIntervals`
- [x] `GET /instrument/compositeIndex`
- [x] `GET /instrument/indicies`

#### Insurance

- [ ] `GET /insurance`

#### Leaderboard

- [ ] `GET /leaderboard`
- [ ] `GET /leaderboard/name`

#### Liquidation

- [ ] `GET /liquidation`

#### Order

- [ ] `GET /order`
- [x] `PUT /order`
- [x] `POST /order`
- [x] `DELETE /order`
- [x] `DELETE /order/all`
- [x] `PUT /order/bulk`
- [ ] `POST /order/bulk`
- [ ] `POST /order/cancelAllAfter`
- [ ] `POST /order/closePosition`

#### OrderBook

- [ ] `GET /orderBook/L2`

#### Position

- [x] `GET /position`
- [ ] `POST /position/isolate`
- [ ] `POST /position/leverage`
- [ ] `POST /position/riskLimit`
- [ ] `POST /position/transferMargin`

#### Quote

- [ ] `GET /quote`
- [ ] `GET /quote/bucketed`

#### Schema

- [ ] `GET /schema`
- [ ] `GET /schema/websocketHelp`

#### Settlement

- [ ] `GET /settlement`

#### Stats

- [ ] `GET /stats`
- [ ] `GET /stats/history`
- [ ] `GET /stats/historyUSD`

#### Trade

- [ ] `GET /trade`
- [ ] `GET /trade/bucketed`

#### User

- [ ] `GET /user`
- [x] `GET /user/affiliateStatus`
- [ ] `POST /user/cancelWithdrawal`
- [ ] `GET /user/checkReferralCode`
- [x] `GET /user/commmission`
- [ ] `POST /user/communicationToken`
- [ ] `POST /user/confirmEmail`
- [ ] `POST /user/confirmWithdrawal`
- [ ] `GET /user/depositAddress`
- [ ] `GET /user/executionHistory`
- [ ] `POST /user/logout`
- [x] `GET /user/margin`
- [ ] `GET /user/minWithdrawalFee`
- [ ] `POST /user/preferences`
- [ ] `GET /user/quoteFillRatio`
- [ ] `POST /user/requestWithdrawal`
- [ ] `GET /user/wallet`
- [ ] `GET /user/walletHistory`
- [ ] `GET /user/walletSummary`

#### UserEvent

- [ ] `GET /userEvent`
