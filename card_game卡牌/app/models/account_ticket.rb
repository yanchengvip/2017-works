class AccountTicket < ApplicationRecord
  self.table_name = 'account_ticket'

  belongs_to :user
  has_many :account_ticket_details
end
