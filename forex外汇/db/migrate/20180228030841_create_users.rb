class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, comment: '用户表' do |t|
      t.string :nickname, comment: '昵称'
      t.string :phone, comment: '手机号'
      t.string :email, comment: '邮箱'
      t.string :password, comment: '密码'
      t.string :salt, comment: '加密随机码'
      t.integer :status, default: 1, comment: '状态;1:启用,2:禁用'
      t.string :head_img, comment: '头像地址'
      t.string :finger_login, comment: '指纹登录账号'
      t.string :finger_password, comment: '指纹登录密码'
      t.string :login_time, comment: '最后一次登录时间'
      t.string :login_device, comment: '登录设备'
      t.string :login_ip, comment: '登录ip地址'
      t.string :token, comment: '登录token'
      t.datetime :token_time, comment: 'token过期时间'
      t.integer :sex, default: 0, comment: '性别 0 未知 1男 2女'
      t.datetime :birthday, comment: '生日'
      t.string :address, comment: '住址'
      t.boolean :is_agree, default: true, comment: '是否同意协议'
      t.text :desc, comment: '简介'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
    add_index :users, :phone
    add_index :users, :token
  end
end
