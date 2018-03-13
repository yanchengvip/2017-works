json.extract! wechat_account, :id, :user_id, :openid, :nickname, :sex, :province, :city, :country, :headimgurl, :request_ip, :active, :unionid, :created_at, :updated_at
json.url wechat_account_url(wechat_account, format: :json)
