class AddPwdAndRedpwdToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :pwd, :string, comment: "mt4交易密码"
    add_column :accounts, :redpwd, :string, comment: "mt4只读密码"
  end
end
