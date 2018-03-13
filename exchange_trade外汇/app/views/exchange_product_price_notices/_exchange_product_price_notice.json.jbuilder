json.extract! exchange_product_price_notice, :id, :user_id, :exchange_product_id, :current_price, :up_price, :down_price, :up_price_end_time, :down_price_end_time, :active, :up_notice, :down_notice, :notice_type, :created_at, :updated_at
json.url exchange_product_price_notice_url(exchange_product_price_notice, format: :json)
