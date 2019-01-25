defmodule ExBitmex.Position do
  @type t :: %ExBitmex.Position{}

  defstruct ~w(
    account
    symbol
    currency
    underlying
    quote_currency
    commission
    init_margin_req
    maint_margin_req
    risk_limit
    leverage
    cross_margin
    deleverage_percentile
    rebalanced_pnl
    prev_realised_pnl
    current_qty
    current_cost
    current_comm
    realised_cost
    unrealised_cost
    gross_open_cost
    gross_open_premium
    mark_price
    mark_value
    home_notional
    foreign_notional
    realised_pnl
    unrealised_gross_pnl
    unrealised_pnl
    liquidation_price
    bankrupt_price
  )a
end
