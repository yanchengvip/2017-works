class AddPromotionActivityIdToAuctionProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :promotion_activity_id, :integer, comment: "活动id"
    add_column :auction_products, :promotion_activity_begin, :datetime, comment: "活动开始时间"
    add_column :auction_products, :promotion_activity_end, :datetime, comment: "活动结束时间"
  end
end
