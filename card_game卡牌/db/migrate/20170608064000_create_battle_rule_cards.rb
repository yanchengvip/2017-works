class CreateBattleRuleCards < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_rule_cards do |t|
      t.integer :card_id, comment: '卡牌表ID'
      t.integer :battle_rule_id, comment: '战役规则表ID'
      t.integer :bout_rank, default: 1, comment: '第几轮'
      t.integer :status, default: 0, comment: '状态，0:正常使用，1：禁用'
      t.integer :card_consume_number, default: 1, comment: '每次使用需消耗卡牌数量'
      t.integer :card_limit_number, default: 0, comment: '每轮限制使用次数，0不限制'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
