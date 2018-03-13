class Api::RedPackagesController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:new_red_package]
  def index
    res = Rails.cache.fetch("read_packages_index_cache", expires_in: 5){
      ahead_of_time = Setting.value("red_package_ahead_of_time").to_i
      red_packages = Promotion::RedPackage.includes(:table).where("begin_time < ? and end_time > ?", Time.now + ahead_of_time, Time.now)
      res  = []
      red_packages.each do |r|
        if r["table_type"] == "ChestRecordItem"
          res << r.as_json.merge(
            chest_prize: ChestPrize.select(:id, :name, :thumbnail).find(r.table.chest_prize_id),
            user: User.select("id", "name", "nick_name", "head_url").find(r.table.user_id),
            "begin_time_stamp": r.begin_time.to_i,
            "end_time_stamp": r.end_time.to_i,
            "begin_count_down": r.begin_time.to_i - Time.now.to_i,
            "end_count_down": r.end_time.to_i - Time.now.to_i
            )
        elsif r["table_type"] == "GameLeague"
          res << r.as_json.merge(
            "begin_time_stamp": r.begin_time.to_i,
            "end_time_stamp": r.end_time.to_i,
            "begin_count_down": r.begin_time.to_i - Time.now.to_i,
            "end_count_down": r.end_time.to_i - Time.now.to_i,
            user: User.select("id", "name", "nick_name", "head_url").find(r.table.champion_id),
            chest_prize: BattleProduct.select(:id, :name, :thumbnail).find(r.table.battle_product_id),
          )
        elsif r["table_type"] == "Mammon::UserWinning"
          res << r.as_json.merge(
            "begin_time_stamp": r.begin_time.to_i,
            "end_time_stamp": r.end_time.to_i,
            "begin_count_down": r.begin_time.to_i - Time.now.to_i,
            "end_count_down": r.end_time.to_i - Time.now.to_i,
            "table_type": "Promotion::RedPackageRecord",
          )
        else
          res << r.as_json.merge(
            "begin_time_stamp": r.begin_time.to_i,
            "end_time_stamp": r.end_time.to_i,
            "begin_count_down": r.begin_time.to_i - Time.now.to_i,
            "end_count_down": r.end_time.to_i - Time.now.to_i
          )
        end
      end
      res
    }
    render json: {"execResult"=>true, "execMsg"=>"", "execData"=>{red_packages: res}, "execDatas"=>[], "execErrCode"=>"200"}
  end

  def draw
    # begin
      red_package = Promotion::RedPackage.find(params[:id])
      res = red_package.draw(current_user)
      render json: res
    # rescue Exception => e
    #   render json: {"execResult"=>false, "execMsg"=>"系统错误", "execData"=>{error: e.as_json}, "execDatas"=>[], "execErrCode"=>"500"}
    # end
  end

  def new_red_package
    begin
      if !params[:table_type].blank? && params[:table_type] == "GameLeague" && !params[:table_id].blank?
        game_league = GameLeague.find(params[:table_id])
        # battle_ids = GameBattleRecord.where(league_id: params[:table_id]).pluck(:id)
        # user_ids = BattleUserRecord.where(battle_id: battle_ids)

        # select finals_game_type_id from game_league where id = 1

        record = GameBattleRecord.where(game_types_id: game_league.finals_game_type_id).first
        win = BattleWinningRecord.where(battle_id: record.id).first
        if win
          rule = Promotion::RedPackageRule.find(game_league.red_package_rule_id)
          if rule.status == 0
            red_package = rule.new_red_package(game_league, Time.now + rule.open_wait_time, Time.now + rule.open_wait_time + rule.close_wait_time )
            render json: {"execResult"=>true, "execMsg"=>"", "execData"=>{red_package: red_package.as_json.merge(begin_time_stamp:red_package.begin_time.to_i, end_time_stamp: red_package.end_time.to_i)}, "execDatas"=>[], "execErrCode"=>"200"}
          else
            render json: {"execResult"=>false, "execMsg"=>"红包已失效", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
          end

        else
          render json: {"execResult"=>false, "execMsg"=>"参数错误", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
        end

  # select id from game_battle_record where  game_types_id = (select finals_game_type_id from game_league where id = 1)
  # select user_id from  battle_winning_record where battle_id = id
      else
        render json: {"execResult"=>false, "execMsg"=>"缺少参数", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
      end
    end
    rescue Exception => e
      render json: {"execResult"=>false, "execMsg"=>"系统错误", "execData"=>{error: e.as_json}, "execDatas"=>[], "execErrCode"=>"500"}
    end

end
