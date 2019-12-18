defmodule ExBitmex.Rest.Orders.CancelBulkTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
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

      assert %ExBitmex.Order{ord_status: "New"} = order

      assert {:ok, orders, _} =
               ExBitmex.Rest.Orders.cancel_bulk(@credentials, %{
                 orders: [%{orderID: order.order_id}]
               })

      assert [%ExBitmex.Order{ord_status: "Canceled"}] = orders
    end
  end
end
