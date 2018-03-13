class DrpUser < ApplicationRecord
  self.table_name = 'user'
  # establish_connection :drp_user_database
  establish_connection :drp_database
  # establish_connection YAML.load_file("config/database.yml").with_indifferent_access.freeze['drp_user_database']
  belongs_to :card_user, class_name: 'User', foreign_key: 'mobile'
end
