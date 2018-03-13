class GameBattleRecord < ApplicationRecord
  self.table_name = 'game_battle_record'
  has_many :battle_user_records#, class_name: 'BattleUserRecord'
end
