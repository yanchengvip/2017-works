json.extract! booking_trade, :id, :account_id, :trade_type, :mt4_account, :symbol, :created_at, :updated_at
json.url booking_trade_url(booking_trade, format: :json)
