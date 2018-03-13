class CreateAdminRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_roles do |t|
      t.integer :admin_id, comment: '管理员id'
      t.integer :role_id, comment: '角色id'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
