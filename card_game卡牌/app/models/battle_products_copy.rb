class BattleProductsCopy < ApplicationRecord
  has_many :images, -> { where(delete_flag: false) }, as: :table
  belongs_to :battle_product
  belongs_to :battle
  belongs_to :product_tag, -> { where(delete_flag: false) }
  after_create :reduce_bp_inventory_count
  after_destroy :increase_bp_inventory_count

  private

  def reduce_bp_inventory_count
    bp = self.battle_product
    if bp.present?
      bp.lock!
      bp.inventory_count -= 1
      bp.save!
    end
  end

  def increase_bp_inventory_count
    bp = self.battle_product
    if bp.present?
      bp.lock!
      bp.inventory_count += 1
      bp.save!
    end
  end

end