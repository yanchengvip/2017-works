class MallProduct < ApplicationRecord
  EXCHANGETYPE = {0 => '功勋', 1 => '微集分', 2 => '功勋或微集分'}
  STATUS = {0 => '下架', 1 => '上架'}
  belongs_to :product_tag
  has_many :images, -> { where(delete_flag: false) }, as: :table
  has_many :mall_orders
  validates :inventory_count, numericality: {greater_than_or_equal_to: 0}
  validates :thumbnail, presence: true


  def self.show_index params
    conditions = []
    values = []
    if params[:name].present?
      conditions << 'name like ?'
      values << "%#{params[:name]}%"
    end
    if params[:exchange_type].present? && params[:exchange_type].to_i != -1
      conditions << 'exchange_type = ?'
      values << params[:exchange_type]
    end
    @mall_products = MallProduct.includes(:mall_orders).where(conditions.join(' and '), *values).active
                         .order('created_at desc').page(params[:page].to_i).per(20)
  end
end