class AuctionPromotionActivityApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_promotion_activity_applies do |t|
      t.integer :promotion_activity_id, comment: "活动id"
      t.integer :provider_id, comment: "供应商id"
      t.integer :status, comment: "状态, 0=>未提交 1=>待审核 2=>驳回 3=>审核通过", default: 0
      t.integer :product_count, comment: "申报的商品个数"
      t.datetime :apply_time, comment: "提交申报时间"
      t.boolean :active, comment: "软删", default: true
      t.timestamps
    end
  end
end
