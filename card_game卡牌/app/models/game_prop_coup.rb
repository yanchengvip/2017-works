class GamePropCoup < ApplicationRecord
  self.table_name = 'game_prop_coup'
  belongs_to :game_prop, foreign_key: 'prop_id'


end
