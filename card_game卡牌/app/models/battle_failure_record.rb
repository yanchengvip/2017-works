class BattleFailureRecord < ApplicationRecord
  self.table_name = 'battle_failure_record'
  belongs_to :battle
  belongs_to :user
  belongs_to :address
  has_many :battle_products_copies,through: :battle
  has_many :battle_packages,through: :battle

end