class AddAlipayAccountAndBalanceToAccountTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :account_ticket, :alipay_account, :string, comment: '支付宝账号'
    add_column :account_ticket, :alipay_name, :string, comment: '支付宝真实姓名'
    add_column :account_ticket, :balance, :decimal, default: 0, precision: 10, scale: 2, comment: '用户现金余额'
  end
end
