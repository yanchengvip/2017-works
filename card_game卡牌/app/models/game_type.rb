class GameType < ApplicationRecord
  belongs_to :game_rule
  # belongs_to :card_bag
  belongs_to :product_tag
  has_many :game_round_cards, -> {where(delete_flag: false)}, dependent: :destroy, as: :table
  belongs_to :game_product_tag
  belongs_to :game_prop

  CONTEST_TYPE = {1 => '公开赛', 2 => '联赛'}

  # after_create :push_to_java

  def push_to_java
    # MsgRecord.apiClient('/card/getRandomCards', { gameTypesId: self.id })
    MsgRecord.apiClient('/card-service-web/card/getRandomCards', { gameTypesId: self.id })
  end

  # def self.push_to_java
  #   MsgRecord.apiClient('/card/getRandomCards', { gameTypesId: 1 })
  # end

  def save_round_cards!(round_cards_params)
    self.game_round_cards.update_all(delete_flag: true)
    round_cards_params && round_cards_params.each do |k, v|
      self.game_round_cards.create!(v.permit!.slice('round_num', 'trick_max', 'choose_max', 'attack_ratio', 'guard_ratio', 'control_ratio', 'choose_time', 'card_bag_id'))
    end
  end

  def clear_redis_data
    MsgRecord.apiClient('/card-service-web/card/updateGameType', {id: self.id, rule: 'GameType'})
  end

end
