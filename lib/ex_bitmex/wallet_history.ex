defmodule ExBitmex.WalletHistory do
  @type t :: %ExBitmex.WalletHistory{}

  defstruct ~w(
    transact_id
    transact_type
    transact_status
    transact_time
    account
    currency
    amount
    fee
    address
    tx
    text
    timestamp
  )a
end
