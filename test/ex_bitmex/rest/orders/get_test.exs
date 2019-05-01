defmodule ExBitmex.Rest.Orders.GetTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExBitmex.Rest

  setup_all do
    HTTPoison.start()
    :ok
  end

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
    :ok
  end

  @credentials %ExBitmex.Credentials{
    api_key: System.get_env("BITMEX_API_KEY"),
    api_secret: System.get_env("BITMEX_API_SECRET")
  }

  test "returns orders by ids" do
    use_cassette "rest/orders/get_orders_by_ids", custom: true do
      ids = ["44ea65b6-b440-4cee-980e-eed36f37f453"]
      params = %{"filter" => %{"orderID" => ids}}

      {:ok, [%ExBitmex.Order{order_id: id}], _rate_limit} = Rest.Orders.get(@credentials, params)

      assert id == List.first(ids)
    end
  end

  test "returns all orders" do
    use_cassette "rest/orders/get_all_orders", custom: true do
      assert {:ok, [%ExBitmex.Order{}], _rate_limit} = Rest.Orders.get(@credentials)
    end
  end
end
