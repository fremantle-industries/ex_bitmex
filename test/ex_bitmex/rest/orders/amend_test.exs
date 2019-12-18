defmodule ExBitmex.Rest.Orders.AmendTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test ".amend returns the order response" do
    use_cassette "rest/orders/amend_ok" do
      assert {:ok, order, _} =
               ExBitmex.Rest.Orders.amend(
                 @credentials,
                 %{
                   orderID: "8d6f2649-7477-4db5-e32a-d8d5bf99dd9b",
                   leavesQty: 3
                 }
               )

      assert order == %ExBitmex.Order{
               side: "Buy",
               transact_time: "2018-11-30T06:06:28.444Z",
               ord_type: "Limit",
               display_qty: nil,
               stop_px: nil,
               settl_currency: "XBt",
               triggered: "",
               order_id: "2e10cc61-f94d-4be2-97e0-14669dda2938",
               currency: "USD",
               peg_offset_value: nil,
               price: 1,
               peg_price_type: "",
               text: "Amended leavesQty: Amended via API.\nSubmitted via API.",
               working_indicator: true,
               multi_leg_reporting_type: "SingleSecurity",
               timestamp: "2018-11-30T06:06:28.444Z",
               cum_qty: 0,
               ord_rej_reason: "",
               avg_px: nil,
               order_qty: 3,
               simple_order_qty: nil,
               ord_status: "New",
               time_in_force: "GoodTillCancel",
               cl_ord_link_id: "",
               simple_leaves_qty: nil,
               leaves_qty: 3,
               ex_destination: "XBME",
               symbol: "XBTUSD",
               account: 10000,
               cl_ord_id: "",
               simple_cum_qty: nil,
               exec_inst: "",
               contingency_type: ""
             }
    end
  end

  test ".amend bubbles other errors" do
    with_mock HTTPoison, request: fn _url -> {:error, %HTTPoison.Error{reason: :timeout}} end do
      assert ExBitmex.Rest.Orders.amend(
               @credentials,
               %{
                 orderID: "8d6f2649-7477-4db5-e32a-d8d5bf99dd9b",
                 leavesQty: 3
               }
             ) == {:error, :timeout, nil}
    end
  end
end
