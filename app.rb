require 'shipping_easy'
require 'rack'
require 'cgi'
require 'openssl'

ShippingEasy.configure do |config|
  config.api_key = '3109d6c25c53437be4cb95a61051b12a'
  config.api_secret = '40043ecc64b1d690c12c42d815fc7e86c8fb2c5d18d354e9c9b427f201b8e6f1'
end

# ShippingEasy::Authenticator.authenticate(method: :post, path: "/callback", body: "{\"shipment\":{\"id\":\"1234\"}}")

class App
  def call(env)
    req = Rack::Request.new(env)
    p = req.params
    now = Time.new

    if !p.empty?
      # puts p.inspect

      shipping_information = p["shipping_information"]

      payload = { "order" => {
        "external_order_identifier" => now.to_i,
        "ordered_at" => now.strftime("%Y-%m-%d %H:%M:%S"),
        # "order_status" => "awaiting_shipment",
        # "subtotal_including_tax" => "10.00",
        # "total_including_tax" => "10.00",
        # "total_excluding_tax" => "10.00",
        # "discount_amount" => "0.00",
        # "coupon_discount" => "1.00",
        # "subtotal_including_tax" => "0.00",
        # "subtotal_excluding_tax" => "0.00",
        # "subtotal_excluding_tax" => "0.00",
        # "subtotal_tax" => "0.00",
        # "total_tax" => "0.00",
        # "base_shipping_cost" => "0.00",
        # "shipping_cost_including_tax" => "0.00",
        # "shipping_cost_excluding_tax" => "0.00",
        # "shipping_cost_tax" => "0.00",
        # "base_handling_cost" => "0.00",
        # "handling_cost_excluding_tax" => "0.00",
        # "handling_cost_including_tax" => "0.00",
        # "handling_cost_tax" => "0.00",
        # "base_wrapping_cost" => "0.00",
        # "wrapping_cost_excluding_tax" => "0.00",
        # "wrapping_cost_including_tax" => "0.00",
        # "wrapping_cost_tax" => "0.00",
        "notes" => "Please send promptly.",
        # "billing_company" => "Acme Inc.",
        # "billing_first_name" => "Fred",
        # "billing_last_name" => "Jones",
        # "billing_address" => "1234 Street",
        # "billing_address2" => "Suite 100",
        # "billing_city" => "Austin",
        # "billing_state" => "TX",
        # "billing_postal_code" => "78701",
        # "billing_country" => "USA",
        # "billing_phone_number" => "512-123-1234",
        # "billing_email" => "test@test.com",
        "recipients" => [
          {
            # "first_name" => "Colin",
            "last_name" => shipping_information["full_name"],
            # "company" => "Wintheiser-Hickle",
            "email" => p["email"],
            # "phone_number" => "637-481-6505",
            # "residential" => "true",
            "address" => shipping_information["street_address"],
            # "address2" => "",
            # "province" => "",
            "state" => shipping_information["state"],
            "city" => shipping_information["city"],
            "postal_code" => shipping_information["zip_code"],
            # "postal_code_plus_4" => "1234",
            "country" => shipping_information["country"],
            # "shipping_method" => "Ground",
            # "base_cost" => "10.00",
            # "cost_excluding_tax" => "10.00",
            # "cost_tax" => "0.00",
            # "base_handling_cost" => "0.00",
            # "handling_cost_excluding_tax" => "0.00",
            # "handling_cost_including_tax" => "0.00",
            # "handling_cost_tax" => "0.00",
            # "shipping_zone_id" => "123",
            # "shipping_zone_name" => "XYZ",
            # "items_total" => "1",
            # "items_shipped" => "0",
            "line_items" => [
              {
                "item_name" => p["permalink"],
                # "sku" => "9876543",
                # "bin_picking_number" => "7",
                # "unit_price" => "1.30",
                # "total_excluding_tax" => "1.30",
                # "weight_in_ounces" => "10",
                # "quantity" => "1",
                # "product_options" => { "color" => "red" }
              }
            ]
          }
        ]
      }}
      
      result = ShippingEasy::Resources::Order.create(store_api_key: "3109d6c25c53437be4cb95a61051b12a", payload: payload)

      return [200, {"Content-Type" => "text/html"}, [result.inspect]]
    else
      return [200, {"Content-Type" => "text/html"}, ["No parameters received"]]
    end
  end
end