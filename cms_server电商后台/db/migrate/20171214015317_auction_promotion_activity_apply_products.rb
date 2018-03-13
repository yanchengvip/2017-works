class AuctionPromotionActivityApplyProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_promotion_activity_apply_products do |t|
      t.integer :promotion_activity_id, comment: "活动id"
      t.integer :provider_id, comment: "供应商id"
      t.integer :promotion_activity_apply_id, comment: "申报id"
      t.integer :product_id, comment: "商品id"
      t.decimal :provider_price, precision: 15, scale: 2, comment: "价格", default: 0
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
  end
end
