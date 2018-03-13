class CreateRecoveries < ActiveRecord::Migration[5.0]
  def change
    create_table :recoveries, comment: "抢兑活动表" do |t|
      t.integer :admin_id, comment: "创建人ID"
      t.decimal :total_cost, precision: 16, scale: 2, comment: "最大花费"
      t.datetime :time_begin, comment: "抢兑开始时间"
      t.datetime :time_end, comment: "抢兑结束时间"
      t.boolean :is_rule, comment: "是否是规则", default: false
      t.integer :chest_prize_id, comment: "抢兑奖品ID", default: 0
      t.integer :total_count, comment: "实际回收奖品数量", default: 0
      t.decimal :actual_cost, precision: 16, scale: 2, comment: "回收实际花费", default: 0
      t.integer :delete_flag, comment: "1 删除", default: 0
      t.integer :recovery_id, comment: "上级抢兑活动ID规则 该记录是根据上级ID配置信息创建", default: 0

      t.timestamps
    end
  end
end
