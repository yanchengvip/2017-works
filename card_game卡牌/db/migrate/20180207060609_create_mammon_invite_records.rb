class CreateMammonInviteRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_invite_records, comment: "邀请记录" do |t|
      t.integer :user_id, comment: "邀请者id"
      t.integer :invite_user_id, comment: "被邀请者id"
      t.integer :period_id, comment: "财神期号ID"
      t.integer :prize_type, comment: "奖励类型 8中 100 是现金 200 是号码 （0-100）式卡牌编号"
      t.integer :prize_count, comment:"奖励数量"
      t.integer :status, comment: "是否发放（领取）0:发放，1:不发放", default: 0
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'
      t.timestamps
    end
  end
end
