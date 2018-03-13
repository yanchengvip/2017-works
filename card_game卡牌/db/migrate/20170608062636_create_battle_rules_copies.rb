class CreateBattleRulesCopies < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_rules_copies, comment: '战役&战役规则关系表，记录战役规则快照' do |t|
      t.integer :battle_id, comment: '战役表ID'
      t.integer :battle_rule_id, comment: '战役规则表ID'
      t.integer :status, default: 0, comment: '战役&战役规则关系表状态;0:启用,1:禁用'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.text :battle_rule_copy, comment: '战役规则快照'
      t.string :name, comment: '战役规则名称'
      t.integer :bout_number, default: 1, comment: '战役号码位数'
      t.integer :open_person_number, default: 1, comment: '开启第一轮最低人数'
      t.integer :bout_time, default: 0, comment: '每轮时间/分钟'
      t.string :desc, comment: '规则描述'
      t.timestamps
    end
  end
end
