class CreateExchangeProductPriceLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_product_price_logs, comment: "外汇品种价格日志" do |t|
      t.integer :exchange_product_id, comment: "外汇品种id"
      t.integer :dealer_id, comment: "券商id"
      t.string :dealer_type, comment: "券商类型"
      t.decimal :price, precision: 16, scale: 6, comment: "当前价格"
      t.datetime :time, comment: "时间戳"
      t.boolean :active, comment: "软删除标志"

      t.timestamps
    end
  end
end
