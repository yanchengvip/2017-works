json.extract! comment, :id, :user_id, :content, :status, :request_ip, :table_id, :table_name, :active, :created_at, :updated_at
json.url comment_url(comment, format: :json)
