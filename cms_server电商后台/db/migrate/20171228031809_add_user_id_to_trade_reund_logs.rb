class AddUserIdToTradeReundLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_trade_refund_logs, :user_id, :integer,comment: '用户ID'
    add_column :auction_unit_refund_logs, :user_id, :integer,comment: '用户ID'
    add_column :auction_trade_status_logs, :user_id, :integer,comment: '用户ID'
  end
end
