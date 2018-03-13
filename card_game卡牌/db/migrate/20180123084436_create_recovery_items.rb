class CreateRecoveryItems < ActiveRecord::Migration[5.0]
  def change
    create_table :recovery_items, comment: "抢兑记录明细" do |t|
      t.integer :chest_prize_id, comment: "奖品ID", default: 0
      t.string :user_id, comment: "用户ID", default: ''
      t.integer :recovery_id, comment: "回收活动ID", default: 0
      t.integer :delete_flag, comment: "1 删除", default: 0
      t.integer :count, comment: "回收数量", default: 0
      t.text :chest_record_item_ids, comment: "奖品明细记录ID"
      t.timestamps
    end
  end
end
