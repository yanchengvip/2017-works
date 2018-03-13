class CardUserThirdParty < ApplicationRecord
  self.table_name = 'user_third_party'
  self.inheritance_column = ""
  # belongs_to :user, class_name: 'User', foreign_key: 'user_id'
end
