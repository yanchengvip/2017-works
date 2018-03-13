class CreateWarnRules < ActiveRecord::Migration[5.0]
  def change
    create_table :warn_rules, comment: '报警规则表' do |t|
      t.integer :battle_rule_id,default: 0,comment: '战役规则表ID'
      t.integer :bout_rank, default: 0, comment: '第几轮'
      t.integer :limit_time_begin, default: 1, comment: '每轮开始后多长时间/分钟'
      t.integer :micro_score, default: 1, comment: '微集分，使用卡牌总价值低于此值则报警'
      t.string :phone, comment: '接收报警手机'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
