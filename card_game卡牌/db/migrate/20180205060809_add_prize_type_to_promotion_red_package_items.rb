class AddPrizeTypeToPromotionRedPackageItems < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_red_package_items, :prize_type, :integer, default: 1, comment: '奖品类型，默认1:现金，2:现金券，3:宝箱符'
    add_column :promotion_red_package_items, :chest_prize_id, :integer, default: 0, comment: '奖品id'
  end
end
