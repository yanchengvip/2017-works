class PackageOrderItem < ApplicationRecord
  belongs_to :package_order
  belongs_to :user
end
