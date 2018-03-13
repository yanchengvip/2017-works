class CreateBattleRulePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_rule_packages do |t|
      t.string :name, comment: '礼包名称'
      t.integer :battle_rule_id, comment: '战役规则ID'
      t.integer :package_id, comment: '礼包ID'
      t.decimal :price, default: 0, precision: 10, scale: 2, comment: '礼包价格'
      t.string :pt_name, comment: '礼包分类: 技巧包,基础包,高级包,土豪包'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
    add_index :battle_rule_packages, :battle_rule_id
    add_index :battle_rule_packages, :package_id
  end
end
