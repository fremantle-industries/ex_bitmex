defmodule ExBitmex.Order do
  @type t :: %ExBitmex.Order{
          side: String.t()
        }

  defstruct ~w(
    side
    transact_time
    ord_type
    display_qty
    stop_px
    settl_currency
    triggered
    order_id
    currency
    peg_offset_value
    price
    peg_price_type
    text
    working_indicator
    multi_leg_reporting_type
    timestamp
    cum_qty
    ord_rej_reason
    avg_px
    order_qty
    simple_order_qty
    ord_status
    time_in_force
    cl_ord_link_id
    simple_leaves_qty
    leaves_qty
    ex_destination
    symbol
    account
    cl_ord_id
    simple_cum_qty
    exec_inst
    contingency_type
  )a
end
