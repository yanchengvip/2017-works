json.extract! financial_record, :id, :account_id, :dealer_id, :amount, :balance, :dealer_type, :active, :created_at, :updated_at
json.url financial_record_url(financial_record, format: :json)
