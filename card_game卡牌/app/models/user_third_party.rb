class UserThirdParty < ApplicationRecord
  self.table_name = 'user_third_party'
  # establish_connection :drp_user_database
  establish_connection :drp_database
  self.inheritance_column = ""
  # establish_connection YAML.load_file("config/database.yml").with_indifferent_access.freeze['drp_user_database']
  belongs_to :card_user, class_name: 'User', foreign_key: 'third_account', primary_key: 'mobile'
  has_many :account_logs, class_name: 'AccountLog', foreign_key: 'user_id'

  belongs_to :account, class_name: 'Account', foreign_key: 'user_id', primary_key: 'user_id'
end
