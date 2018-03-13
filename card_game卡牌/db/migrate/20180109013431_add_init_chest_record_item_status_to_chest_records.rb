class AddInitChestRecordItemStatusToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :init_chest_record_item_status, :integer, default: 0, comment: "奖品明细记录是否生成 0 待生成  1生成完毕"
  end
end
