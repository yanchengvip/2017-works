class AddLevelToAccountTicketBalanceDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :account_ticket_balance_details, :level, :integer, default: -1, comment: '奖品等级：-1=无，0：特等奖，1=一等奖，2=二等级，3=三等级'
    remove_column :mammon_user_winnings, :status
  end
end
