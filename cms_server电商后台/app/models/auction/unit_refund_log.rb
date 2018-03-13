class Auction::UnitRefundLog < ApplicationRecord
  belongs_to :auction_unit, :class_name => 'Auction::Unit',foreign_key: 'unit_id'
end
