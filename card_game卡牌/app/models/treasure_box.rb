class TreasureBox < ApplicationRecord
  self.table_name = 'game_treasure_box'
  has_many :jackpots, -> {where(delete_flag: false)}, dependent: :destroy


  def has_master?
    res = false
    if !self.jackpots.where(is_master: true).blank?
      res = true
    end

    return res
  end

  def master_jackpot
    self.jackpots.where(is_master: true).first
  end

  def save_week_gifts!(week_params)
    self.level_gifts.where(gift_type: 0).update_all(delete_flag: true)
    week_params && week_params.each do |param|
      self.level_gifts.create!(param.permit!.slice('gifts_id', 'gifts_num').merge(gift_type: 0))
    end
  end

  def save_up_gifts!(up_params)
    self.level_gifts.where(gift_type: 1).update_all(delete_flag: true)
    up_params && up_params.each do |param|
      self.level_gifts.create!(param.permit!.slice('gifts_id', 'gifts_num').merge(gift_type: 1))
    end
  end

  def save_jackpot! jackpot_params, level1s, level2s, level3s, is_master = false
    jackpot = self.jackpots.create!(jackpot_params.permit!.slice('name', 'num', 'fund').merge(is_master: is_master))

    level1s.each do |k, v|
      jackpot.jackpot_products.create!(v.permit!.slice('type', 'product_id' , 'num', 'fund', 'count').merge(level: 1).merge(base_num: level1s['num']))
    end

    level2s.each do |k, v|
      jackpot.jackpot_products.create!(v.permit!.slice('type', 'product_id' , 'num', 'fund', 'count').merge(level: 1).merge(base_num: level2s['num']))
    end

    jackpot.jackpot_products.create!(level3s.permit!.slice('type', 'product_id' , 'num', 'fund', 'count').merge(level: 3).merge(base_num: level3s['num']))
  end

end
