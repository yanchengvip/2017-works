class CreateManageEditorRoleRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :manage_editor_role_relationships, comment: "用户-角色多对多关联表" do |t|
      t.integer :editor_id, comment: "编辑ID"
      t.boolean :active, comment: "软删", default: true
      t.integer :role_id, comment: "角色ID"

      t.timestamps
    end
  end
end
