class ChestPrize < ApplicationRecord
  audited #日志记录
  # 奖品类型
  PRIZE_TYPE = {1 => '实物', 2 => '入场券', 3 => '兑奖券', 5 => '宝箱券', 6 => '现金券', 7 => '话费', 9 => '京东卡', 10 => '现金', 11 => "财神号码", 12 => "财神卡牌-单枪", 13 => "财神卡牌-嫁祸", 14 => "财神卡牌-消耗", 15 => "财神卡牌-反抢", 16 => "财神卡牌-增幅", 17 => "财神卡牌-互换", 18 => "财神卡牌-群抢"}

  ENTITY_TYPES = [1, 7, 9] #实物奖品类型
  # PRIZE_TYPE = {1 => '实物', 2 => '入场券', 3 => '兑奖券', 4 => '参赛券', 5 => '宝箱券', 6 => '现金券', 7 => '话费', 8 => 'Q币', 9 => '京东卡', 10 => '现金'}
  # 获取后, 跳转场景
  JUMP_TYPE = {1 => '抢兑商品', 2 => '兑奖阁', 3 => '领取录入', 4 => '确认（回到宝箱页面）'}
  IS_PRIOR = {0 => '否', 1 => '是'}
  PHONE_FEE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 50, 100, 200, 300, 500]

  has_many :chest_box_prizes, -> { where(delete_flag: false) }
  validates_numericality_of :exchange, greater_than_or_equal_to: 0, less_than_or_equal_to: 100, message: '献祭比例必须为大于0小于100的整数'

  #根据IDs获取奖品信息
  def self.get_prizes_by_ids ids
    res = []
    ids.split(",").each do |id|
      r = self.get_prize_by_id id
      res << r unless r.blank?
    end
    res.sort{|x, y| x["price"] <=> y["price"]}
  end

  def self.get_prize_by_id id
    Rails.cache.fetch("chest_prize_cache:#{id}", expires_in: 3600){
      res = ChestPrize.where(id: id).first
      if res
        res.as_json
      else
        {}
      end
    }
  end

  before_save :check_fee
  def check_fee
    if self.prize_type == 7 && !self.num.to_i.in?(ChestPrize::PHONE_FEE)
      raise '话费充值金额必须是固定数值'
    end
    if self.prize_type == 7
      self.num = self.num.to_i
    end
  end

  after_save :resize_image
  def resize_image
    if self.thumbnail_changed?
      img_url = FASTDFSCONFIG[:fastdfs][:tracker_url] + self.thumbnail

      image_114 = MiniMagick::Image.open img_url
      image_114.resize "114x114"

      image_267 = MiniMagick::Image.open img_url
      image_267.resize "267x267"

      @storage = $tracker.get_storage
      res_114 = @storage.upload File.open(image_114.path)
      res_267 = @storage.upload File.open(image_267.path)

      self.update_columns(t114: "/#{res_114[:result][:group_name]}/#{res_114[:result][:path]}", t267: "/#{res_267[:result][:group_name]}/#{res_267[:result][:path]}")

    end
  end


end
