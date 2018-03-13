class ChangePreDiscountTotalToAuctionPromotionActivities < ActiveRecord::Migration[5.1]
  def change
    remove_column :auction_promotion_activities, :pre_discount_total
    add_column :auction_promotion_activities, :pre_discount_total, :decimal, precision: 15, scale: 2, comment: "每满XX减XX-最大优惠值"
  end
end
