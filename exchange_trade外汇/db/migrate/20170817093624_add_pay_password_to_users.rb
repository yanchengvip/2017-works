class AddPayPasswordToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pay_password, :string, comment: "支付密码"
  end
end
