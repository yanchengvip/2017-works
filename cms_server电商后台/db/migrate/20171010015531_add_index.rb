class AddIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :manage_editors, [:email, :active], unique: true
    add_index :manage_authorities, [:action, :active], unique: true
    add_index :supplier_providers, [:login, :active], unique: true
    add_index :supplier_report_forms, [:provider_id, :date, :active], unique: true
    add_index :auction_seckills, [:product_id, :date, :play, :active], unique: true, name: "auction_seckills_product_id_unique"
    add_index :manage_editor_role_relationships, [:editor_id, :role_id], name: "editor_id_role_id_index"
    add_index :manage_authority_role_relationships, [:role_id, :authority_id], name: "role_id_authority_id_index"
  end
end
