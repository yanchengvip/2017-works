class CreateMammonAttackRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_attack_records, comment: "攻击记录表" do |t|
      t.string :from_user_id, comment: "攻击者ID"
      t.string :to_user_id, comment: "被攻击者ID"
      t.integer :period_id, comment: "财神期号ID", default: 0
      t.text :codes, comment: "攻击获得号码明细 多个号码英文逗号分隔"
      t.integer :card_id,  comment: "技能牌", default: 0
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
