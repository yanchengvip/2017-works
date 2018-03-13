class BattleUserRecord < ApplicationRecord
  self.table_name = 'battle_user_record'
  belongs_to :game#, class_name: 'Game', foreign_key: 'battle_id'
  belongs_to :user

end
