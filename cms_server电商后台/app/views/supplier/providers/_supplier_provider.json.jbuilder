json.extract! supplier_provider, :id, :name, :description, :active, :login, :password, :salt, :created_at, :updated_at
json.url supplier_provider_url(supplier_provider, format: :json)
