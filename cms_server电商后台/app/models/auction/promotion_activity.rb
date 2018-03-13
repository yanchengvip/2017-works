class Auction::PromotionActivity < ApplicationRecord
  has_many :category, class_name: 'Auction::PromotionActivityCategory', foreign_key: 'promotion_activity_id'
  has_many :supplier, class_name: 'Auction::PromotionActivitySupplier', foreign_key: 'promotion_activity_id'
  has_many :apply, -> {where(active: true,status: 3)}, class_name: 'Auction::PromotionActivityApply', foreign_key: 'promotion_activity_id'
  has_many :check_log, class_name: 'Auction::CheckLog', foreign_key: 'activity_id'
  DISCOUNTTYPE = { 1 => '连拍折扣', 2 => '每满减', 3 => '满减'}
  STATUS = {0 => '未审批', 1 => '待审批', 2 => '驳回', 3 => '通过', 4 => '已结束', 5 => '待总监审核', 6 => '待财务审核'}
  APPOINTSUPPLIER = {1 => '全部供应商', 2 => '指定供应商'}
  APPOINTCATEGORY = {1 => '全部分类', 2 => '指定商品分类'}
  attr_accessor :supplier_id, :category_id
end
