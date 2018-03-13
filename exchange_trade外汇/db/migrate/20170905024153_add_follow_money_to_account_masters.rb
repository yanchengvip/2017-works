class AddFollowMoneyToAccountMasters < ActiveRecord::Migration[5.1]
  def change
    add_column :account_masters, :follow_money,:decimal, precision: 16, scale: 6, comment: '跟随金额'
    remove_column :account_tactics,:follow_money
  end
end
