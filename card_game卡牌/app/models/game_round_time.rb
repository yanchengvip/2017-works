class GameRoundTime < ApplicationRecord
  belongs_to :table, polymorphic: true
end
