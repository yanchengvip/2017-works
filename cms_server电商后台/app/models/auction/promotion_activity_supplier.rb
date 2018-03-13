class Auction::PromotionActivitySupplier < ApplicationRecord
  belongs_to :provider,class_name: 'Manage::Provider',foreign_key: :supplier_id
  belongs_to :promotion_activity,class_name: 'Auction::PromotionActivity',foreign_key: :promotion_activity_id
end
