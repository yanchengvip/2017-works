class Auction::PromotionActivityApplyProduct < ApplicationRecord
  belongs_to :product,class_name: 'Auction::Product',foreign_key: :product_id
  belongs_to :provider,class_name: 'Manage::Provider',foreign_key: :provider_id
  belongs_to :promotion_activity,class_name: 'Auction::PromotionActivity',foreign_key: :promotion_activity_id
end
