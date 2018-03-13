class Card < ApplicationRecord
  audited #日志记录
  # Card_type = [[1, '进攻卡'], [2, '防御卡'], [3, '控制卡'], [4, '史诗类']]
  CARDTYPE = {1 => '进攻类', 2 => '防御类', 3 => '效果类'}
  CARD_ATTR = ['name', 'summary', 'thumbnail', 'price', 'details', 'operator_id', 'operator_name', 'cooldown', 'order_num', 'video_url', 'energy', 'attack_energy', 'use_times', 'forage', 'attack_full', 'attack_curr', 'control_full', 'control_curr', 'defense_full', 'defense_curr', 'consume_full', 'consume_curr', 'cool_full', 'instruction']

  validates :name, presence: true
  validates :name, uniqueness: { scope: :delete_flag, message: "卡牌名称不能重复"}
  validates :order_num, uniqueness: { scope: :delete_flag, message: "卡牌排序不能重复"}
  validates_presence_of :summary, :thumbnail

  has_many :images, as: :table

  scope :epics, -> {where(code: ['100011'])}
  scope :not_epics, -> {where.not(code: ['100011'])}

  before_save :deal_transfer_percent

  def in_use?
    self.delete_flag == false
  end

  # 进攻类
  def is_attack?
    self.card_type == 1
  end

  # 防御类
  def is_defense?
    self.card_type == 2
  end

  # 效果类
  def is_effect?
    self.card_type == 3
  end

  def self.available_nums
    num_arr = Card.active.map(&:order_num)
    used_num = num_arr - [0]
    count = num_arr.size
    ok_num = (1..count).to_a - used_num
    return ok_num
  end

  # 参数cardId
  def clear_redis_data
    MsgRecord.apiClient('/card-service-web/card/updateRedisCardsInfo', {cardId: self.id})
  end

  def self.attacks
    self.where(card_type: 1).pluck(:id)
  end

  def self.guards
    self.where(card_type: 2).pluck(:id)
  end

  def self.controls
    self.where(card_type: 3).pluck(:id)
  end


  private
  def deal_transfer_percent
    if self.transfer_percent.present?
      self.transfer_percent = self.transfer_percent * 0.01
      self.attack_energy = self.attack_energy * 0.01
    end
  end
end
