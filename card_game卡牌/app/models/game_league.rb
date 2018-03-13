class GameLeague < ApplicationRecord
  self.table_name = 'game_league'
  has_many :game_league_battles, -> {where(delete_flag: false)}, dependent: :destroy, class_name: 'GameLeagueBattle'
  STATUS = {1 => '联赛开始', 2 => '资格赛开始', 3 => '资格赛结束', 4 => '淘汰赛开始', 5 => '淘汰赛结束', 6 => '联赛结束'}
  PRIZE_TYPE = {1 => '兑奖券', 2 => '宝箱符', 3 => '入场券'}
  belongs_to :red_package_rule, class_name: 'Promotion::RedPackageRule'
  belongs_to :battle_product
  before_save :check_time

  def save_items! game_img_params, robot_difficulty_params, robot_prize_params
    self.game_league_battles.update_all(delete_flag: true) unless self.new_record?
    3.times do |i|
      self.game_league_battles.create!(
        battle_num: i+1,
        head_image: game_img_params[(i+1).to_s]['head_image'],
        ourt_image: game_img_params[(i+1).to_s]['ourt_image'],
        robot_ratio: robot_difficulty_params[(i+1).to_s]['robot_ratio'],
        robot_num: robot_difficulty_params[(i+1).to_s]['robot_num'],
        prize_type: robot_prize_params[(i+1).to_s]['prize_type'],
        prize_type_num: robot_prize_params[(i+1).to_s]['prize_type_num'],
      )
    end
  end

  def copy!
    res = {status: false, msg: '复制失败'}
    glbs = self.game_league_battles
    begin
      ActiveRecord::Base.transaction do
        league = GameLeague.create!(self.attributes.except("id", 'league_name', "status", "created_at", "updated_at", "preliminaries_end", "knockout_begin", 'league_begin', 'league_end', 'champion_id', 'battle_winning_id').merge(league_name: self.league_name + '-copy'))
        if league
          glbs.each do |glb|
            league.game_league_battles.create!(glb.attributes.except("id", "game_league_id", "created_at", "updated_at"))
          end
          res = {status: true, msg: '复制成功'}
        end
      end
    rescue Exception => e
      res = {status: false, msg: '复制失败' + e.to_s}
    end

    res
  end

  def push_to_java
    MsgRecord.apiClient('/card-service-web/admin/updateRedisGameLeague')
  end

  def java_stop
    MsgRecord.apiClient('/admin/stopRedisGameLeague', {leagueId: self.id})
  end

  def check_time
    if self.league_begin_changed? || self.league_end_changed?
      # openings = GameLeague.active.where("league_begin < ? and league_end > ?", Time.now, Time.now)
      can_openings = GameLeague.active.where("league_end > ?", Time.now)
      can_openings && can_openings.each do |game|
        next if game.id == self.id
        # if (self.league_begin >= game.league_begin && self.league_begin <= game.league_end) || (self.league_end >= game.league_begin && self.league_end <= game.league_end)
        unless self.league_end <= game.league_begin || self.league_begin >= game.league_end
          raise '联赛时间不能交叉'
        end
      end
    end
  end

end

