json.extract! account, :id, :user_id, :dealer_id, :dealer_type, :status, :agent_account, :mt4_account, :mt4_group, :name, :email, :phone, :certificate, :certificate_num, :created_at, :updated_at
json.url account_url(account, format: :json)
