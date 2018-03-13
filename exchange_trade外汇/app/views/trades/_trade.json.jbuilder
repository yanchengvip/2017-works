json.extract! trade, :id, :account_id, :mt4_account, :order_code, :symbol, :digits, :cmd, :volume, :open_time, :open_price, :created_at, :updated_at
json.url trade_url(trade, format: :json)
