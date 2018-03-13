json.extract! supplier_trade, :id, :auction_trade_id, :provider_id, :status, :price, :payment_price, :tax_price, :active, :delivery_service, :delivery_identifier, :ship_at, :remark, :delivery_phone, :balance_price, :finish_at, :created_at, :updated_at
json.url supplier_trade_url(supplier_trade, format: :json)
