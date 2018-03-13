class CreateAuctionPromotionActivitySuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_promotion_activity_suppliers do |t|
      t.integer :promotion_activity_id
      t.integer :supplier_id
      t.boolean :active, comment: "软删字段 true 已删除", default: true

      t.timestamps
    end
  end
end
