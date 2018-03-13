class CreateExchangeProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :exchange_products, comment: "外汇品种" do |t|
      t.string :symbol, comment: "外汇品种标志"
      t.boolean :active, comment: "软删除标志"
      t.boolean :published, comment: "是否发布"

      t.timestamps
    end
  end
end
