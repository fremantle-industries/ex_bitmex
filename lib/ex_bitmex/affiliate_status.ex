defmodule ExBitmex.AffiliateStatus do
  @type t :: %ExBitmex.AffiliateStatus{}

  defstruct ~w(
    account
    currency
    prev_payout
    prev_turnover
    prev_comm
    prev_timestamp
    exec_turnover
    exec_comm
    total_referrals
    total_turnover
    total_comm
    payout_pcnt
    pending_payout
    timestamp
    referrer_account
    referral_discount
    affiliate_payout
  )a
end
