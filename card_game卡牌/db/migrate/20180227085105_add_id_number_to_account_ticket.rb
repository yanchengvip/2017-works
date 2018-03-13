class AddIdNumberToAccountTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :account_ticket, :id_number, :string, comment: "身份证号"
    add_index :account_ticket, :id_number, unique: true
    add_index :account_ticket, :alipay_account, unique: true
  end
end
