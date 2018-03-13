json.extract! medal, :id, :name, :condition, :medal_type, :image, :content, :enable, :active, :created_at, :updated_at
json.url medal_url(medal, format: :json)
