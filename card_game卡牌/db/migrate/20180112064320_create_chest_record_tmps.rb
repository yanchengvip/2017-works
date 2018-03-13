class CreateChestRecordTmps < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_record_tmps, comment: "推广宝箱用户奖品临时记录表" do |t|
      t.integer :chest_box_id, comment: "宝箱ID", default: 0
      t.integer :chest_box_chest_type, comment: "宝箱类型", default: 0
      t.string :chest_prize_ids, comment: "奖品IDs", default: ""
      t.integer :delete_flag, comment:"删除标志", default: 0
      t.integer :status, comment: "状态 0 未同步  1已经绑定用户 -1已经过期", default: 0
      t.string :mobile, comment:"领奖手机号码", default: ""

      t.timestamps
    end
    add_index :chest_record_tmps, [:mobile, :chest_box_chest_type]
  end
end
