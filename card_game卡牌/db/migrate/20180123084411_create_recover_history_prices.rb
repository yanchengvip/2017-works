class CreateRecoverHistoryPrices < ActiveRecord::Migration[5.0]
  def change
    create_table :recover_history_prices, comment: "抢兑历史价格" do |t|
      t.integer :recovery_id, comment: "抢兑规则ID", default: 0
      t.decimal :price, precision: 16, scale: 2, default: 0, comment: "当日回收价"
      t.integer :delete_flag, default: 0, comment: "1 已删除"
      t.string :day, comment: "日期"
      t.timestamps
    end
    add_index :recover_history_prices, [:recovery_id, :day], unique: true
  end
end
