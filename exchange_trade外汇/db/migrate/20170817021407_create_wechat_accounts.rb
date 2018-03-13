class CreateWechatAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :wechat_accounts, comment: '微信用户' do |t|
      t.integer :user_id, default: 0, comment: 'user表ID'
      t.string :openid, commnet: '微信openid'
      t.string :nickname, comment: '微信昵称'
      t.integer :sex, default: 0, comment: '性别；0:未知,1:男,2:女'
      t.string :province, comment: '省'
      t.string :city, comment: '市'
      t.string :country, comment: '国家'
      t.string :headimgurl, comment: '头像'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'
      t.string :unionid, comment: '只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段'

      t.timestamps
    end

    add_index :wechat_accounts,:user_id,unique: true
    add_index :wechat_accounts,:openid,unique: true
  end
end
