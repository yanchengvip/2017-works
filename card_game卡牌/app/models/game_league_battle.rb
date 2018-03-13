class GameLeagueBattle < ApplicationRecord
  self.table_name = 'game_league_battle'
  belongs_to :game_league
end

