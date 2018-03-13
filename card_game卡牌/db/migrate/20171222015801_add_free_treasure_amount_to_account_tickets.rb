class AddFreeTreasureAmountToAccountTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :account_ticket, :free_treasure_amount, :integer, default: 0, comment: '免费宝符'
  end
end
