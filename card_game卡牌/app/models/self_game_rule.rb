class SelfGameRule < ApplicationRecord
  # belongs_to :card_bag
  has_many :game_round_times, -> {where(delete_flag: false)}, dependent: :destroy, as: :table
  has_many :game_round_cards, -> {where(delete_flag: false)}, dependent: :destroy, as: :table

  def save_round_times!(round_times_params)
    self.game_round_times.update_all(delete_flag: true)
    round_times_params && round_times_params.each do |round|
      self.game_round_times.create!(round_num: round['round_num'], round_time: round['round_time'])
    end
  end

  def save_round_cards!(round_cards_params)
    self.game_round_cards.update_all(delete_flag: true)
    round_cards_params && round_cards_params.each do |k, v|
      self.game_round_cards.create!(v.permit!.slice('round_num', 'trick_max', 'choose_max', 'attack_ratio', 'guard_ratio', 'control_ratio', 'choose_time', 'card_bag_id'))
    end
  end

  def clear_redis_data
    MsgRecord.apiClient('/card-service-web/card/updateGameType', {id: self.id, rule: 'SelfGameRule'})
  end


end
