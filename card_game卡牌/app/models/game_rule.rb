class GameRule < ApplicationRecord
  has_many :game_types
  has_many :game_round_times, -> {where(delete_flag: false)}, dependent: :destroy, as: :table


  def save_round_times!(round_times_params)
    self.game_round_times.update_all(delete_flag: true)
    round_times_params && round_times_params.each do |round|
      self.game_round_times.create!(round_num: round['round_num'], round_time: round['round_time'])
    end
  end


end
