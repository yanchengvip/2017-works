class AddPhonecardIdsToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :phonecard_prizes_status, :integer, default: 0, comment: "电话卡充值状态 0 不需要充值 1 代充值  2 充值中  3 充值成功"
    add_column :chest_records, :voucher_prizes_status, :integer, default: 0, comment: "优众现金券 状态 0 不需要充值 1 待发券  3 发券成功"
  end
end
