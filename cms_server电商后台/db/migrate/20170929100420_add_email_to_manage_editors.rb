class AddEmailToManageEditors < ActiveRecord::Migration[5.1]
  def change
    add_column :manage_editors, :email, :string, comment: "邮箱"
    add_column :manage_editors, :password, :string, comment: "密码"
    add_column :manage_editors, :salt, :string, comment: "加密混淆字段"
  end
end
