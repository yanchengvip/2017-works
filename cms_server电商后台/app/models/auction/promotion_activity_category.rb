class Auction::PromotionActivityCategory < ApplicationRecord
  belongs_to :category,class_name: 'Auction::Category',foreign_key: :category_id
end
