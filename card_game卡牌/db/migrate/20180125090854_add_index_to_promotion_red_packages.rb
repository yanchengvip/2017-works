class AddIndexToPromotionRedPackages < ActiveRecord::Migration[5.0]
  def change
    add_index :promotion_red_packages, [:table_type, :table_id], unique: true
  end
end
