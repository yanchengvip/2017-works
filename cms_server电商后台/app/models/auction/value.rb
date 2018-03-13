class Auction::Value < ApplicationRecord
  belongs_to :product
  belongs_to :product_attribute
  # belongs_to :attributer, class_name: 'Auction::Attribute', foreign_key: 'attribute_id'
end
