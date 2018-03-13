class AddProfitToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :profit, :decimal, precision: 16, scale: 6, comment: "收益、盈亏", default: 0
    add_column :accounts, :yield_rate, :decimal, precision: 16, scale: 6, comment: "收益率", default: 0
    add_column :accounts, :winrate, :decimal, precision: 16, scale: 6, comment: "胜率", default: 0
    add_column :accounts, :sl, :decimal, precision: 16, scale: 6, comment: "最大亏损", default: 0
    add_column :accounts, :tp, :decimal, precision: 16, scale: 6, comment: "最大盈利", default: 0
    add_column :accounts, :total_follow_trade_num, :integer, comment: "跟随人数", default: 0
    add_column :accounts, :total_follow_trade_price, :decimal, precision: 16, scale: 6, comment: "跟随金额", default: 0
  end
end
