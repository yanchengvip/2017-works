class CreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins, comment: '管理员表' do |t|
      t.string :nickname, comment: '登录名'
      t.string :phone, comment: '手机号'
      t.string :password, comment: '密码'
      t.string :salt, comment: '加密随机码'
      t.integer :status, default: 0, comment: '状态  0正常，1禁用'
      t.string :real_name, comment: '真实姓名'
      t.string :email, comment: '邮箱'
      t.string :login_ip, comment: '登录ip地址'
      t.datetime :login_time, comment: '最后一次登录时间'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
