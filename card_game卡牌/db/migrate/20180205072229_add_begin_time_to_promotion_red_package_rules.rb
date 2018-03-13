class AddBeginTimeToPromotionRedPackageRules < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_red_package_rules, :begin_time, :string, comment: '开始时间'
    add_column :promotion_red_package_rules, :is_auto, :boolean, default: false, comment: '是否自动触发'
  end
end
