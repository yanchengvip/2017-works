class CreatePromotionRedPackageRuleItems < ActiveRecord::Migration[5.0]
  def change
    create_table :promotion_red_package_rule_items, comment: '红包规则明细' do |t|
      t.decimal :amount, precision: 16, scale: 2, comment: '金额'
      t.integer :count, default: 0, comment: '数量'
      t.integer :red_package_rule_id, default: 0, comment: '红包规则id'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
    add_index :promotion_red_package_rule_items, :red_package_rule_id
  end
end
