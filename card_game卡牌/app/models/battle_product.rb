class BattleProduct < ApplicationRecord
  STATUS = {0 => '下架', 1 => '上架'} #状态
  belongs_to :product_tag
  has_many :images, -> { where(delete_flag: false) }, as: :table
  validates :inventory_count, numericality: {greater_than_or_equal_to: 0}
  validates :thumbnail, presence: true
  belongs_to :game_product_tag
  # belongs_to :mall_product_tag
  # before_save :deal_mall_product_tag_ids
  after_save :deal_null_data

  has_many :jackpot_products, -> { where(delete_flag: false) }, as: :product
  PRODUCT_TYPE = {0 => '普通商品', 1 => '手机充值', 2 => '入场券', 3 => '兑奖券', 4 => '宝箱符'}
  PHONE_FEE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 50, 100, 200, 300, 500]


  def deal_mall_product_tag_ids
    if self.mall_product_tag_ids
      self.mall_product_tag_ids = self.mall_product_tag_ids.join(',')
    end
  end

  #商品列表显示
  def self.show_index params
    conditions = []
    values = []
    if params[:name].present?
      conditions << 'name like ?'
      values << "%#{params[:name]}%"
    end
    if params[:product_tag].present? && params[:product_tag].to_i != -1
      conditions << 'product_tag_id = ?'
      values << params[:product_tag]
    end
    if params[:status].present? && params[:status].to_i != -1
      conditions << 'status = ?'
      values << params[:status]
    # elsif params[:status].to_i != -1
    #   params[:status] = 1
    #   conditions << 'status = ?'
    #   values << params[:status]
    end

    if params[:is_game_product].present? && params[:is_game_product].to_i != -1
      conditions << 'is_game_product = ?'
      values << params[:is_game_product]
    end

    if params[:is_self_game_product].present? && params[:is_self_game_product].to_i != -1
      conditions << 'is_self_game_product = ?'
      values << params[:is_self_game_product]
    end

    if params[:is_mall_product].present? && params[:is_mall_product].to_i != -1
      conditions << 'is_mall_product = ?'
      values << params[:is_mall_product]
    end

    if params[:inventory_count_begin].present?
      conditions << 'inventory_count >= ?'
      values << params[:inventory_count_begin]
    end

    if params[:inventory_count_end].present?
      conditions << 'inventory_count <= ?'
      values << params[:inventory_count_end]
    end

    @battle_products = BattleProduct.where(conditions.join(' and  '),*values)
                           .includes(:product_tag).where(delete_flag: false).order('created_at desc')
                           .page(params[:page].to_i).per(20)
  end

  def self.product_tag_ids
    self.active.pluck(:product_tag_id).uniq
  end

  def shelf! is_game_product_param, is_self_game_product_param, is_mall_product_param
    is_game_product_param = is_game_product_param == 'true' ? true : false
    is_self_game_product_param = is_self_game_product_param == 'true' ? true : false
    is_mall_product_param = is_mall_product_param == 'true' ? true : false

    self.update_attributes!(is_game_product: is_game_product_param, is_self_game_product: is_self_game_product_param, is_mall_product: is_mall_product_param)
  end

  def deal_null_data
    if self.score.blank?
      self.update_attributes!(score: 0)
    end
    if self.glory.blank?
      self.update_attributes!(glory: 0)
    end
  end

end
