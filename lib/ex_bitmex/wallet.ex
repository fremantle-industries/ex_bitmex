defmodule ExBitmex.Wallet do
  @type t :: %ExBitmex.Wallet{}

  defstruct ~w(
    account
    currency
    prev_deposited
    prev_withdrawn
    prev_transfer_in
    prev_transfer_out
    prev_amount
    prev_timestamp
    delta_deposited
    delta_withdrawn
    delta_transfer_in
    delta_transfer_out
    delta_amount
    deposited
    withdrawn
    transfer_in
    transfer_out
    amount
    pending_credit
    pending_debit
    confirmed_debit
    timestamp
    addr
    script
    withdrawal_lock
  )a
end
