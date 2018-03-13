class Game < ApplicationRecord
  self.table_name = 'game_battle_record'

  belongs_to :game_type, -> { includes [:game_rule, :product_tag] }, foreign_key: 'game_types_id'
  has_many :battle_user_records, foreign_key: 'battle_id'
  has_one :battle_winning_record, foreign_key: 'battle_id'

end
