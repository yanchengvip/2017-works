class GluttonSetting < ApplicationRecord
  has_many :glutton_energy_prizes, -> {where(delete_flag: false)}, dependent: :destroy
  has_many :glutton_texts, -> {where(delete_flag: false)}, dependent: :destroy
  has_many :glutton_dead_prizes, -> {where(delete_flag: false)}, dependent: :destroy

  validates_numericality_of :appear_time, greater_than_or_equal_to: 0, message: '开始后X秒必须为大于等于0的整数'
  validates_numericality_of :attack_time, greater_than_or_equal_to: 0, message: '每隔X秒攻击必须为大于等于0的整数'
  validates_numericality_of :attack_user_key, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'
  # validates :round_blood, presence: true
  # validates_numericality_of :last_blood_energy, greater_than_or_equal_to: 0, message: '最后击杀饕餮的用户获得的能量必须为大于等于0的整数'
  # validates_numericality_of :max_blood_energy, greater_than_or_equal_to: 0, message: '对饕餮伤害最大的用户获得的能量必须为大于等于0的整数'
  validates_numericality_of :restart_time, greater_than_or_equal_to: 0, message: '持续 X 秒必须为大于等于0的整数'
  validates_numericality_of :immune_seal_ratio, greater_than: 0, message: '持续 X 秒必须为大于0的整数'
  validates_numericality_of :enabling_ratio, greater_than: 0, message: '持续 X 秒必须为大于0的整数'

  validates_numericality_of :offer_energy_percent, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'
  validates_numericality_of :broadcast_blood, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'
  validates_numericality_of :broadcast_key, greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: '百分比必须大于0小于1'

  before_validation :set_percents

  def self.save_gluttons! params, glutton_energy_prize_params, glutton_text_params
    glutton = GluttonSetting.new(params)
    glutton.attack_user_key = glutton.attack_user_key * 0.01
    if bloods_param.present?
      glutton.round_blood = bloods_param.join(',')
    end

    res = glutton.save!

    return res
  end

  def save_prizes_and_texts! glutton_energy_prize_params, glutton_text_params, round_params
    # 临界点奖励
    glutton_energy_prize_params && glutton_energy_prize_params.each do |item_param|
      if item_param['id'] && (at_item = self.glutton_energy_prizes.find(item_param['id'].to_i))
        at_item.update!(item_param.to_hash.slice('blood_percent', 'energy_percent'))
      elsif item_param['id'].blank?
        self.glutton_energy_prizes.create!(item_param.to_hash.slice('blood_percent', 'energy_percent'))
      end
    end

    # 语言提示
    glutton_text_params && glutton_text_params.each do |item_param|
      if item_param['id'] && (at_item = self.glutton_texts.find(item_param['id'].to_i))
        at_item.update!(item_param.to_hash.slice('blood_percent', 'show_text'))
      elsif item_param['id'].blank?
        self.glutton_texts.create!(item_param.to_hash.slice('blood_percent', 'show_text'))
      end
    end

    # 饕餮死亡奖励
    GluttonDeadPrize.active.update_all(delete_flag: true)
    6.times do |index|
      self.glutton_dead_prizes.create!(roundth: index + 1, last_blood_energy: round_params["last_blood_energy_#{index + 1}"], max_blood_energy: round_params["max_blood_energy_#{index + 1}"])
    end

  end

  def self.clear_redis_data
    MsgRecord.apiClient('/card-service-web/glutton/queryGlutton')
  end

  private
  def set_percents
    self.attack_user_key = self.attack_user_key * 0.01
    self.offer_energy_percent = self.offer_energy_percent * 0.01
    self.broadcast_blood = self.broadcast_blood * 0.01
    self.broadcast_key = self.broadcast_key * 0.01
  end


end
