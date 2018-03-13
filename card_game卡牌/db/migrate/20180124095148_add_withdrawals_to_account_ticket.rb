class AddWithdrawalsToAccountTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :account_ticket, :withdrawals, :decimal, default: 0, precision: 10, scale: 2, comment: '已提现金额'
  end
end
