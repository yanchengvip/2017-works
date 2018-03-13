class CreateAuctionReviewLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_review_logs do |t|
      t.integer :product_id, default: 0, comment: '商品id'
      t.string :product_name, default: '', comment: '商品名称'
      t.integer :discount, default: 0, comment: "优众价"
      t.integer :provider_price, default: 0, comment: "供货价"
      t.decimal :profit_margin, precision: 4, scale: 2, default: 0, comment: '毛利率'
      t.integer :editor_id, default: 0, comment: '审核用户id'
      t.string :review_result, default: '', comment: '审核结果'

      t.timestamps
    end

    add_index :auction_review_logs, :product_id
    add_index :auction_review_logs, :editor_id
  end
end
