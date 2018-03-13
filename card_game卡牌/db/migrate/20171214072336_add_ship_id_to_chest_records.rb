class AddShipIdToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :address_id, :integer, comment: "收货地址ID"
    add_column :chest_records, :address_info, :text, comment: "收货地址json"
    add_column :chest_records, :status, :integer, comment: "领取奖品 0 未领取 1已领取 2献祭", default: 0
    add_column :chest_records, :receive_time, :datetime, comment: "领取时间"
    add_column :chest_records, :ship_status, :integer, default: 0, comment: "发货状态 0 未发货， 1 已发货 2 待支付 3 已支付 4 到付"
    add_column :chest_records, :ship_admin_id, :integer, comment: "发货人"
    add_column :chest_records, :ship_at, :datetime, comment: "发货时间"
    add_column :chest_records, :ship_server, :string, comment: "快递公司"
    add_column :chest_records, :ship_code, :datetime, comment: "快递单号"
  end
end
