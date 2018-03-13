class CreateAuctionExchangeRates < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_exchange_rates, comment: "汇率表" do |t|
      t.string :from, comment: "初始币种"
      t.string :to, comment: "转换目标币种"
      t.integer :amount, comment: "初始币种数量"
      t.decimal :price, precision: 16, scale: 6, comment: "目标币种数量"
      t.string :day, comment: "发布时间"
      t.boolean :active, comment: "软删字段", default: true

      t.timestamps
    end
  end
end
