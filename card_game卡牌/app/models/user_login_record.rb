class UserLoginRecord < ApplicationRecord
  self.table_name = 'user_login_record'
  belongs_to :user
end
