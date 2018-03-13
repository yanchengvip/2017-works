class Address < ApplicationRecord
    self.table_name = 'address'
    belongs_to :user
end
