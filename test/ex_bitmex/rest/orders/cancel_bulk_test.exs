defmodule ExBitmex.Rest.Orders.CancelBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_SECRET")
  }

  test ".cancel_bulk returns a list of results" do
    use_cassette "rest/orders/cancel_bulk_ok" do
      {:ok, order, _} =
        ExBitmex.Rest.Orders.create(
          @credentials,
          %{
            symbol: "XBTUSD",
            side: "Buy",
            orderQty: 1,
            price: 1
          }
        )

      assert order == %ExBitmex.Order{
               stop_px: nil,
               ex_destination: "XBME",
               transact_time: "2019-01-29T04:00:14.894Z",
               peg_offset_value: nil,
               working_indicator: true,
               price: 1,
               text: "Submitted via API.",
               ord_rej_reason: "",
               triggered: "",
               contingency_type: "",
               time_in_force: "GoodTillCancel",
               ord_type: "Limit",
               cl_ord_id: "",
               simple_order_qty: nil,
               currency: "USD",
               cum_qty: 0,
               side: "Buy",
               exec_inst: "",
               leaves_qty: 1,
               simple_leaves_qty: nil,
               display_qty: nil,
               symbol: "XBTUSD",
               peg_price_type: "",
               timestamp: "2019-01-29T04:00:14.894Z",
               cl_ord_link_id: "",
               multi_leg_reporting_type: "SingleSecurity",
               account: 158_898,
               simple_cum_qty: nil,
               ord_status: "New",
               order_qty: 1,
               settl_currency: "XBt",
               avg_px: nil,
               order_id: "3215a4ba-1c5a-db58-92d6-1c0b5f129c80"
             }

      assert {:ok, orders, _} =
               ExBitmex.Rest.Orders.cancel_bulk(
                 @credentials,
                 %{orders: [%{orderID: order.order_id}]}
               )

      assert orders == [
               %ExBitmex.Order{
                 stop_px: nil,
                 ex_destination: "XBME",
                 transact_time: "2019-01-29T04:00:14.894Z",
                 peg_offset_value: nil,
                 working_indicator: false,
                 price: 1,
                 ord_rej_reason: "",
                 triggered: "",
                 contingency_type: "",
                 time_in_force: "GoodTillCancel",
                 ord_type: "Limit",
                 cl_ord_id: "",
                 simple_order_qty: nil,
                 currency: "USD",
                 cum_qty: 0,
                 side: "Buy",
                 exec_inst: "",
                 leaves_qty: 0,
                 simple_leaves_qty: nil,
                 display_qty: nil,
                 symbol: "XBTUSD",
                 peg_price_type: "",
                 timestamp: "2019-01-29T04:00:15.234Z",
                 cl_ord_link_id: "",
                 multi_leg_reporting_type: "SingleSecurity",
                 account: 158_898,
                 text: "Canceled: Canceled via API.\nSubmitted via API.",
                 simple_cum_qty: nil,
                 ord_status: "Canceled",
                 order_qty: 1,
                 settl_currency: "XBt",
                 avg_px: nil,
                 order_id: "3215a4ba-1c5a-db58-92d6-1c0b5f129c80"
               }
             ]
    end
  end
end
