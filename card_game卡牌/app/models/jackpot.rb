# game_jackpot
class Jackpot < ApplicationRecord
  self.table_name = 'game_jackpot'
  belongs_to :treasure_box
  has_many :jackpot_products, -> {where(delete_flag: false)}, dependent: :destroy


end
