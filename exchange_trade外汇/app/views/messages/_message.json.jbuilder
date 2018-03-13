json.extract! message, :id, :msg_type, :body, :user_ids, :active, :created_at, :updated_at
json.url message_url(message, format: :json)
