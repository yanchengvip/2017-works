class CreateAuctionSeckills < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_seckills, comment: "秒杀活动" do |t|
      t.integer :product_id, comment: "商品ID", dafault: 0
      t.decimal :discount, precision: 16, scale: 2, comment: "秒杀、价格", dafault: 0
      t.string :date, comment: "秒杀日期", dafault: ""
      t.integer :play, comment: "场次", dafault: 1
      t.boolean :active, comment: "软删标志", default: true
      t.integer :user_id, comment: "编辑ID", default: 0

      t.timestamps
    end
  end
end
