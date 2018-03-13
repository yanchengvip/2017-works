class Auction::Coupon < ApplicationRecord
  belongs_to :event,class_name: 'Auction::Event',foreign_key: :event_id
  FUNCTION = { 'add_point' => '加积分', 'add_voucher' => '加代金券', 'add_point_and_voucher' => '加积分和代金券' }
end
