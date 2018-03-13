class Package < ApplicationRecord
  has_many :package_items, -> {where(delete_flag: false)}, dependent: :destroy
  belongs_to :package_type
  has_many :images, as: :table
  has_many :battle_packages
  has_many :operate_logs, as: :table

  validates_presence_of :name, :package_type_id, :summary, :sale_channels
  # , :offshelf_time, :thumbnail, :prize_type, :total_count, :total_limit, :day_limit
  validates :price, presence: true

  scope :not_onshelf, -> {where(status: 0)}
  scope :is_onshelf, -> {where(status: 1)}


  validate :check_time

  before_save :check_status

  # accepts_nested_attributes_for :package_items, reject_if: lambda { |item| item[:package_id].blank? && item[:prize_range].blank?  }, allow_destroy: false


  # 销售渠道
  # Sale_channel = [[1, '卡牌商城'], [2, '战场']]
  SALECHANNEL = {1 => '商城', 2 => '战场', 3 => '战役兑换'}

  PRIZETYPE = {1 => '固定礼包', 2 => '随机礼包', 3 => '等值随机'}

  SHELFSTATUS = {-1 => '已下架', 0 => '未上架', 1 => '已上架'}


  def save_package(params)
    #立即上架
    # if self.prize_type !=3 && params[:shelf_time_type].to_i == 0
    #   self.onshelf_time = Time.now
    #   self.status = 1
    # end
    # self.icon_url = 'test'
    # 销售渠道，多个
    # if params[:sale_channels].present?
    #   self.sale_channels = params[:sale_channels].join(',')
    # end
    res = self.save

    return res
  end

  def save_package_items(params)
    params && params.each do |item|
      self.package_items.create!(item.to_hash.slice('prize_range', 'win_count', 'prize_type'))
    end
    # if self.status == 1 && self.package_items.blank?
    #   self.update_attributes!(status: 0)
    # end
  end

  def save_images(params)
    params.each do |url|
      self.images.create(url: url)
    end
  end

  # 修改礼包的内容
  def update_package_items(params)
    # if origin_prize_type != self.prize_type
    #   self.package_items.map(&:destroy)
    # end
    params && params.each do |item|
      if item['package_item_id'] && (pk_item = self.package_items.where(id: item['package_item_id'].to_i).first)
        pk_item.update(item.to_hash.slice('prize_range', 'win_count', 'prize_type'))
      elsif item['package_item_id'].blank?
        self.package_items.create!(item.to_hash.slice('prize_range', 'win_count', 'prize_type'))
      end
    end
    if self.status == 1 && self.package_items.blank?
      self.update_attributes!(status: 0)
    end
  end

  # 修改礼包的图片
  def update_package_items_images(params)
    params.each do |url|
      if self.images.where(url: url).first.blank?
        self.images.create(url: url)
      end
    end
  end

  def update_package(params)
    # if self.prize_type != 3 && shelf_time_type.to_i == 0
    #   params.merge!({'onshelf_time' => Time.now, 'status' => 1})
    # end
    # 销售渠道
    # if sale_channels.present?
    #   params.merge!({'sale_channels' => sale_channels.join(',')})
    # end

    self.update!(params)
  end

  # 自动上架，等值随机礼包只能手动上架
  def self.auto_onshelf!
    Package.active.where("prize_type <> 3").not_onshelf.each do |package|
      if package.onshelf_time <= Time.now
        package.update_attributes!(status: 1, onshelf_time: Time.now)
      end
    end
  end

  # 自动下架
  def self.auto_offshelf!
    Package.active.is_onshelf.each do |package|
      if package.offshelf_time <= Time.now
        package.update_attributes!(status: -1, offshelf_time: Time.now)
      end
    end
  end

  # 保存方案
  def save_package_item_scheme(params)
    return false if (params[:package_items][:prize_range]&.size != (params[:package_items][:range_count] - [''])&.size)
    prize_range = params[:package_items][:prize_range].join(',')
    range_count = (params[:package_items][:range_count] - ['']).join(',')
    price = params[:package_items_price]
    if params[:package_item_id].present?
      package_item = self.package_items.where("id = ?", params[:package_item_id]).first
      package_item.update_attributes!(prize_range: prize_range, range_count: range_count, price: price)
    else
      self.package_items.create!(prize_type: '卡牌', prize_range: prize_range, range_count: range_count, price: price, lottery_times: 1, win_count: 1)
    end
  end

  # 是否可上架，等值随机礼包，没有配置方案不能上架
  def can_onshelf?
    return !self.package_items.blank?
  end

  # 检查礼包价值（防修改）和方案配置价值是否相差超过配置最大值
  def item_scheme_price_ok
    ok = true
    over_range = SYSTEMCONFIG[:admin_config][:fix_price_over].presence || 10
    items = self.package_items.select('id, price')
    items.each do |item|
      ok = false if (item.price&.to_f - self.fix_price&.to_f).abs > over_range
    end
    return ok
  end


  private
  # 等值随机礼包只能手动上架
  def check_time
    if self.prize_type != 3 && self.onshelf_time.present?
      errors.add(:base, "上架时间必须小于下架时间") if self.onshelf_time >= self.offshelf_time
    end
  end

  def check_status
    if self.status == -1
      self.status == 0
    end
  end

end
