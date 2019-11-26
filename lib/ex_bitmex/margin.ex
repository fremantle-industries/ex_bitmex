defmodule ExBitmex.Margin do
  @type t :: %ExBitmex.Margin{}

  defstruct ~w(
    account
    currency
    risk_limit
    prev_state
    state
    action
    amount
    pending_credit
    pending_debit
    confirmed_debit
    prev_realised_pnl
    prev_unrealised_pnl
    gross_comm
    gross_open_cost
    gross_open_premium
    gross_exec_cost
    gross_mark_value
    risk_value
    taxable_margin
    init_margin
    maint_margin
    session_margin
    target_excess_margin
    var_margin
    realised_pnl
    unrealised_pnl
    indicative_tax
    unrealised_profit
    synthetic_margin
    wallet_balance
    margin_balance
    margin_balance_pcnt
    margin_leverage
    margin_used_pcnt
    excess_margin
    excess_margin_pcnt
    available_margin
    withdrawable_margin
    timestamp
    gross_last_value
    commission
  )a
end
