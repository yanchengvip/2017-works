class CreateRoleAuthorityResources < ActiveRecord::Migration[5.0]
  def change
    create_table :role_authority_resources do |t|
      t.integer :role_id, comment: 'role表ID'
      t.integer :authority_resource_id, comment: 'authority_resource表ID'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
    end
  end
end
