class CreateWechatUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :wechat_users, comment: '微信用户' do |t|
      t.integer :user_id, comment: '用户ID'
      t.string :openid, comment: '微信的openid'
      t.string :nickname, comment: '微信昵称'
      t.integer :sex, default: 0, comment: '性别 0 未知 1男 2女'
      t.string :city, comment: '城市'
      t.string :province, comment: '省份'
      t.string :country, comment: '国家'
      t.string :head_img, comment: '头像地址'
      t.string :login_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :wechat_users, :user_id
    add_index :wechat_users, :openid, :unique => true
  end
end
