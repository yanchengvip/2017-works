class Auction::PromotionActivityApply < ApplicationRecord
  STATUS = {0 => '未提交', 1 => '待审核', 2 => '驳回', 3 => '通过', 4 => '申报结束'}
  belongs_to :provider,class_name: 'Manage::Provider',foreign_key: :provider_id
  belongs_to :promotion_activity,class_name: 'Auction::PromotionActivity',foreign_key: :promotion_activity_id
  has_many :apply_products,class_name: 'Auction::PromotionActivityApplyProduct',foreign_key: :promotion_activity_apply_id
end
