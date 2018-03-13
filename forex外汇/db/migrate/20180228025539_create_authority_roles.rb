class CreateAuthorityRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :authority_roles, comment: '权限角色关系表' do |t|
      t.integer :authority_id, dedault: 0, comment: '权限ID'
      t.integer :role_id, dedault: 0, comment: '角色ID'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
