class CreateAdminRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_roles, comment: '管理员角色关系表' do |t|
      t.integer :admin_id, default: 0, comment: '管理员ID'
      t.integer :role_id, default: 0, comment: '角色ID'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
