class CreateBattleRules < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_rules, comment: '战役规则表' do |t|
      t.string :name, comment: '战役规则名称'
      t.integer :status, default: 0, comment: '状态;0:启用,1:禁用'
      t.integer :bout_number, default: 1, comment: '战役号码位数'
      t.integer :open_person_number, default: 1, comment: '开启第一轮最低人数'
      t.integer :bout_time, default: 1, comment: '每轮时间/分钟'
      t.string :desc, comment: '规则描述'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
