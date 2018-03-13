class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, comment: '用户表' do |t|
      t.string :nickname, comment: '用户名'
      t.string :phone, comment: '手机号', null: true
      t.string :password_digest, comment: '密码'
      t.integer :status, default: 1, comment: '状态;1:启用,2:禁用'
      t.string :salt, comment: '加密随机码'
      t.string :headimgurl, comment: '头像 "headimgurl": {"url": "", #原图 "t80_80": { "url": ""}#其他尺寸切图},'
      t.datetime :last_login_time, comment: '最后一次登录时间'
      t.string :login_device, comment: '登录设备'
      t.string :token, comment: '登录token', null: true
      t.boolean :is_agree, default: true, comment: '是否同意协议'
      t.datetime :expire_time, comment: 'token过期时间'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :users, :nickname
    add_index :users, :phone,unique: true
    add_index :users, :token,unique: true

  end
end
