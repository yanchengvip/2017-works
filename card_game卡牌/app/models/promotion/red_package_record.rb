class Promotion::RedPackageRecord < ApplicationRecord
  belongs_to :red_package_rule
  has_one :red_package, -> { where(delete_flag: false) }, as: :table
end
