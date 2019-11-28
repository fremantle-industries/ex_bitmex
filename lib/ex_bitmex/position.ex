defmodule ExBitmex.Position do
  @type t :: %ExBitmex.Position{
          account: pos_integer,
          symbol: String.t(),
          currency: String.t(),
          underlying: String.t(),
          quote_currency: String.t(),
          commission: float,
          init_margin_req: float,
          maint_margin_req: float,
          risk_limit: integer,
          leverage: pos_integer,
          cross_margin: boolean,
          deleverage_percentile: nil | term,
          rebalanced_pnl: integer,
          prev_realised_pnl: float,
          prev_unrealised_pnl: float,
          prev_close_price: float,
          opening_timestamp: String.t(),
          opening_qty: non_neg_integer,
          opening_cost: float,
          opening_comm: integer,
          open_order_buy_qty: non_neg_integer,
          open_order_buy_cost: float,
          open_order_buy_premium: float,
          open_order_sell_qty: non_neg_integer,
          open_order_sell_cost: float,
          open_order_sell_premium: float,
          exec_buy_qty: non_neg_integer,
          exec_buy_cost: float,
          exec_sell_qty: non_neg_integer,
          exec_sell_cost: float,
          exec_qty: non_neg_integer,
          exec_cost: float,
          exec_comm: float,
          current_timestamp: String.t(),
          current_qty: non_neg_integer,
          current_cost: float,
          current_comm: float,
          realised_cost: float,
          unrealised_cost: float,
          gross_open_cost: float,
          gross_open_premium: float,
          gross_exec_cost: float,
          is_open: boolean,
          mark_price: float | nil,
          mark_value: float,
          risk_value: float,
          home_notional: float,
          foreign_notional: float,
          pos_state: String.t(),
          pos_cost: float,
          pos_cost2: float,
          pos_cross: float,
          pos_init: float,
          pos_comm: float,
          pos_loss: float,
          pos_margin: float,
          pos_maint: float,
          pos_allowance: float,
          taxable_margin: float,
          init_margin: float,
          maint_margin: float,
          session_margin: float,
          target_excess_margin: float,
          var_margin: float,
          realised_gross_pnl: float,
          realised_tax: float,
          realised_pnl: float,
          unrealised_gross_pnl: float,
          long_bankrupt: float,
          short_bankrupt: float,
          tax_base: float,
          indicative_tax_rate: float,
          indicative_tax: float,
          unrealised_tax: float,
          unrealised_pnl: float,
          unrealised_pnl_pcnt: float,
          unrealised_roe_pcnt: float,
          simple_qty: pos_integer | nil,
          simple_cost: float | nil,
          simple_value: float | nil,
          simple_pnl: float | nil,
          simple_pnl_pcnt: float | nil,
          avg_cost_price: float | nil,
          avg_entry_price: float | nil,
          break_even_price: float | nil,
          margin_call_price: float | nil,
          liquidation_price: float | nil,
          bankrupt_price: float | nil,
          timestamp: String.t(),
          last_price: float | nil,
          last_value: float
        }

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
    prev_unrealised_pnl
    prev_close_price
    opening_timestamp
    opening_qty
    opening_cost
    opening_comm
    open_order_buy_qty
    open_order_buy_cost
    open_order_buy_premium
    open_order_sell_qty
    open_order_sell_cost
    open_order_sell_premium
    exec_buy_qty
    exec_buy_cost
    exec_sell_qty
    exec_sell_cost
    exec_qty
    exec_cost
    exec_comm
    current_timestamp
    current_qty
    current_cost
    current_comm
    realised_cost
    unrealised_cost
    gross_open_cost
    gross_open_premium
    gross_exec_cost
    is_open
    mark_price
    mark_value
    risk_value
    home_notional
    foreign_notional
    pos_state
    pos_cost
    pos_cost2
    pos_cross
    pos_init
    pos_comm
    pos_loss
    pos_margin
    pos_maint
    pos_allowance
    taxable_margin
    init_margin
    maint_margin
    session_margin
    target_excess_margin
    var_margin
    realised_gross_pnl
    realised_tax
    realised_pnl
    unrealised_gross_pnl
    long_bankrupt
    short_bankrupt
    tax_base
    indicative_tax_rate
    indicative_tax
    unrealised_tax
    unrealised_pnl
    unrealised_pnl_pcnt
    unrealised_roe_pcnt
    simple_qty
    simple_cost
    simple_value
    simple_pnl
    simple_pnl_pcnt
    avg_cost_price
    avg_entry_price
    break_even_price
    margin_call_price
    liquidation_price
    bankrupt_price
    timestamp
    last_price
    last_value
  )a
end
