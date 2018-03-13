class AddChestBoxOpenTypeToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :chest_box_open_type, :integer, default: 0, comment: "1免费（邀请注册获得抽奖次数）， 2宝符（付费购买）"
  end
end
