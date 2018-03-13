class AddRedPackageRuleIdToChestBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_box_prizes, :red_package_rule_id, :integer, default: 0, comment: '红包规则id'
  end
end
