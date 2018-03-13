class AddClaimTimesMaxToPromotionRedPackageRules < ActiveRecord::Migration[5.0]
  def change
    add_column :promotion_red_package_rules, :claim_times_max, :integer, default: 1, comment: '单用户最多可领取次数， 默认为1'
  end
end
