class CreateAuctionSkus < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_skus, comment: '商品sku' do |t|
      t.integer :product_id, comment:"商品id", default: 0
      t.boolean :active, comment:"软删除标志", default: true
      t.string :name, comment:"sku名称 如：XL, XXL", default: ""
      t.integer :amount, comment:"库存数量", default: 0
      t.string :code, comment:"sku编码", default: ""

      t.timestamps
    end
  end
end
