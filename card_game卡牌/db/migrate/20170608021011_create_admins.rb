class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :nickname, comment: '昵称，登录名'
      t.string :phone, comment: '手机号'
      t.string :encrypted_password, comment: '密码'
      # t.integer :role_id, comment: '用户角色'
      t.string :salt
      t.integer :status, default: 1, comment: '用户状态 -1:删除,0:禁用,1:正常'
      t.string :name, comment: '姓名'
      t.string :email, comment: '邮箱'
      t.string :request_ip, comment: '最近登陆ip'
      t.datetime :last_login_time, comment: '最后登录时间'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
