class CreateManageAuthorityRoleRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :manage_authority_role_relationships, comment: "角色-权限多对多关系表" do |t|
      t.integer :authority_id, comment: "权限ID"
      t.integer :role_id, comment: "角色ID"
      t.boolean :active, comment: "软删标志", default: true

      t.timestamps
    end
  end
end
