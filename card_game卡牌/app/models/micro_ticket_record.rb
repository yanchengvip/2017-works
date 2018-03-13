class MicroTicketRecord < ApplicationRecord
  self.table_name = 'micro_ticket_record'
  belongs_to :user
end
