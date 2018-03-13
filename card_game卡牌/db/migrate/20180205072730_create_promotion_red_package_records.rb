class CreatePromotionRedPackageRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_red_package_records do |t|
      t.integer :red_package_rule_id, default: 0, comment: '规则id'
      t.string :day, comment: '触发日期'
      t.string :memo, comment: '备注'

      t.timestamps
    end

    add_index :promotion_red_package_records, [:red_package_rule_id, :day], name: 'package_rule_day', unique: true
  end
end
