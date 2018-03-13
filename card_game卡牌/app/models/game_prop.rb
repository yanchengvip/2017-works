class GameProp < ApplicationRecord
  self.table_name = 'game_prop'
  has_many :game_prop_coups, -> {where(delete_flag: false)}, dependent: :destroy, foreign_key: 'prop_id'

  has_many :jackpot_products, -> { where(delete_flag: false) }, as: :product

  LOW_GAME = {false => '否', true => '是'}
  CONFIG_TYPE = {1 => '指定计谋', 2 => '随机计谋'}


  def save_prop_coup!(game_prop_coup_params)
    self.game_prop_coups.update_all(delete_flag: true)
    game_prop_coup_params && game_prop_coup_params.each do |grcp|
      self.game_prop_coups.create!(grcp.permit!.slice('card_id', 'card_num'))
    end
  end

  def self.clear_redis_data
    MsgRecord.apiClient('/card-service-web/gameLuckies/loadInitRedis', {})
  end

end
