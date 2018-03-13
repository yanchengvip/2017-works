class AddIndexToAdminRoles < ActiveRecord::Migration[5.0]
  def change
    add_index :admin_roles, [:admin_id, :role_id, :delete_flag], name: 'admn_role_index_uq', unique: true
  end
end
