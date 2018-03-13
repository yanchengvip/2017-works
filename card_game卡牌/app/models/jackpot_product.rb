class JackpotProduct < ApplicationRecord
  self.table_name = 'game_jackpot_products'
  self.inheritance_column = ""
  belongs_to :jackpot, foreign_key: 'jackpot_id'
  # belongs_to :product, class_name: 'BattleProduct', foreign_key: 'product_id'
  # belongs_to :game_prop, class_name: 'GameProp', foreign_key: 'product_id'
  belongs_to :product, polymorphic: true

  validates :type, presence: true

  after_save :set_product_type

  def set_product_type
    if self.type == '3' && self.product_type.blank?
      self.update_attributes!(product_type: 'GameProp')
    elsif self.type == '4' && self.product_type.blank?
      self.update_attributes!(product_type: 'BattleProduct')
    end
  end


end
