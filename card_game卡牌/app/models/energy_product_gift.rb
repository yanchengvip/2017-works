class EnergyProductGift < ApplicationRecord
  belongs_to :energy_product

  # validates_uniqueness_of :buy_times, scope: [:delete_flag, :energy_product_id]
end
