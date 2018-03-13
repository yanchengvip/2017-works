class Promotion::RedPackageRuleItem < ApplicationRecord
  belongs_to :red_package_rule
  PRIZE_TYPE = {"现金" => 1, "现金券" => 2, "宝箱符"  => 3}
end
