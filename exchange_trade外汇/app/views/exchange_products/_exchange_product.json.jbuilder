json.extract! exchange_product, :id, :symbol, :active, :published, :created_at, :updated_at
json.url exchange_product_url(exchange_product, format: :json)
