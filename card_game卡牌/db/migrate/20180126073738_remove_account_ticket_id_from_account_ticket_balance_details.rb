class RemoveAccountTicketIdFromAccountTicketBalanceDetails < ActiveRecord::Migration[5.0]
  def change
    remove_column :account_ticket_balance_details, :account_ticket_id, :integer
  end
end
