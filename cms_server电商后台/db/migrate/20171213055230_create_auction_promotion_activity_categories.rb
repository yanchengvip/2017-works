class CreateAuctionPromotionActivityCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_promotion_activity_categories do |t|
      t.integer :promotion_activity_id
      t.integer :category_id
      t.boolean :active, comment: "软删字段 true 已删除", default: true

      t.timestamps
    end
  end
end
