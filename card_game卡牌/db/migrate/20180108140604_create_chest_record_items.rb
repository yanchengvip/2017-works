class CreateChestRecordItems < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_record_items, comment: "抽奖奖品记录明细表" do |t|
      t.integer :chest_record_id, comment: "抽奖记录ID", default: 0
      t.integer :chest_prize_id, comment: "奖品ID", default: 0
      t.string :user_id, comment: "用户ID", default: "0"
      t.integer :chest_box_id, comment: "宝箱ID", default: 0
      t.integer :status, comment: "状态 0未领取 1已领取 2已支付 3发货中 4已发货", default: 0
      t.integer :prize_type, comment: "奖品类型", default: 0
      t.integer :level, comment: "奖品等级", default: 0
      t.timestamps
    end
  end
end
