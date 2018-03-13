class Auction::Voucher < ApplicationRecord
  belongs_to :user,class_name: 'Core::Account',foreign_key: :user_id
  belongs_to :event,class_name: 'Auction::Event',foreign_key: :event_id
end
