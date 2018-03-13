class Dealer < ApplicationRecord
  has_many :user
  DealerType = {1 => '虚拟券商', 2 => '约汇网券商'}
end
