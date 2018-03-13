class GameRoundCard < ApplicationRecord
  belongs_to :table, polymorphic: true
  belongs_to :card_bag

  # validates_presence_of :table_id, :table_type, :round_num, :card_bag_id
  before_save :calc_ratio

  def calc_ratio
    raise '比例错误' if (self.attack_ratio + self.guard_ratio + self.control_ratio) != self.trick_max
  end
end
