class AddAppointSupplierToAuctionPromotionActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_promotion_activities, :appoint_supplier, :integer, comment: "指定供应商分类 1=全部供应商 2> 指定供应商 "
    add_column :auction_promotion_activities, :appoint_category, :integer, comment: "指定商品分类  1=>全部 2> 指定"
  end
end
