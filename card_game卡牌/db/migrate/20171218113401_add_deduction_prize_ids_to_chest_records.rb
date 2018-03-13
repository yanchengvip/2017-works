class AddDeductionPrizeIdsToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :deduction_prize_ids, :string, default: "", comment: "用户不满足获奖规则扣除的奖品"
    change_column :chest_records, :chest_prize_ids, :string, default: "", comment: "用户获奖奖品ID， 字符串 逗号分隔"
  end
end
