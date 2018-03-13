class CreateSupplierProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_providers, comment: "供应商" do |t|
      t.string :name, comment: "姓名"
      t.string :description, comment: "描述"
      t.boolean :active, comment: "软删", default: true
      t.string :login, comment: "账号"
      t.string :password, comment: "密码"
      t.string :salt, comment: "加密混淆字段"

      t.timestamps
    end
  end
end
