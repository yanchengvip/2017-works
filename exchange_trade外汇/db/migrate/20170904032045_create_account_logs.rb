class CreateAccountLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :account_logs, comment: "账户每日盈亏 净值记录表" do |t|
      t.string :day, comment: "记录日期"
      t.integer :account_id, comment: "账户id", index: true
      t.decimal :profit, precision: 16, scale: 6, comment: "盈亏"
      t.decimal :equity, precision: 16, scale: 6, comment: "净值"
      t.decimal :balance, precision: 16, scale: 6, comment: "余额"
      t.decimal :margin, precision: 16, scale: 6, comment: "保证金"
      t.decimal :margin_free, precision: 16, scale: 6, comment: "可用保证金"
      t.boolean :active, default: true, comment: "软删除字段"
      t.timestamps
    end
    add_index :account_logs, %i(day account_id active), unique: true
  end
end
