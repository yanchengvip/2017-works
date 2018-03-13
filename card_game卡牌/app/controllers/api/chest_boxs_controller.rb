class Api::ChestBoxsController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:index, :left_prize_count, :notice, :prizes, :current_notice, :h5_landing_box, :h5_landing_binding_mobile, :app_landing_box, :app_landing_box_detail, :h5_box_detail, :syn_user]

  def syn_user
    crt = ChestRecordTmp.where(mobile: params[:mobile], status: 0).last
    user = User.where(login_name: "18101341113").last

    if user && crt
      crt.to_chest_record(user)
      render json: {"execResult"=>true, "execMsg"=>"", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"200"}
    else
      render json: {"execResult"=>true, "execMsg"=>"该用户没有抽奖结果", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"200"}
    end
  end

  #app开屏宝箱
  def app_landing_box
    chest_box = ChestBox.current(5)
    if chest_box
      res = chest_box.draw_app_landing_box

      render json: res
    else
      render json:{"execResult"=>false, "execMsg"=>"没有可开启宝箱", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
    end
  end

  #app 开屏宝箱奖品信息
  def app_landing_box_detail
    chest_box = ChestBox.current(5)
    if chest_box
      chest_prizes = chest_box.chest_prizes.where("chest_box_prizes.is_prior = true")
      res = {chest_box: chest_box,
        chest_prizes: chest_prizes.as_json.map { |x| x.merge({level: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level})},
        big_chest_prize: chest_box.chest_prizes.where(id: chest_box.big_prize_id).first.as_json
      }
      render json: {"execResult"=>true, "execMsg"=>"", "execData"=>res, "execDatas"=>[], "execErrCode"=>"200"}
    else
      render json:{"execResult"=>false, "execMsg"=>"没有可开启宝箱", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
    end
  end

  #app绑定开奖结果到用户
  def app_box_binding_user
    if params[:sign] && params[:id] && ChestBox.sa_verify(params[:id].to_s, params[:sign], SYSTEMCONFIG[:rsa][:public_key]) && (tmp = ChestRecordTmp.where(id: params[:id], status: 0).first)
      res = tmp.to_chest_record(current_user)
      render json: res
    else
      render json:{"execResult"=>false, "execMsg"=>"", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
    end
  end

  #h5 宝箱广告页面数据接口
  def h5_box_detail
    last_count = Rails.cache.fetch("last_count:#{Date.today.to_s}", expires_in: 3600 * 24){
      500000
    }.to_i
    last_count_time = Rails.cache.fetch("last_count_time:#{Date.today.to_s}", expires_in: 3600 * 24){
      0
    }.to_i

    left_count = last_count - (rand(10) + 1) * (Time.now - Time.now.at_beginning_of_day - last_count_time ).to_i

    Rails.cache.write("last_count:#{Date.today.to_s}", left_count)
    Rails.cache.write("last_count_time:#{Date.today.to_s}", Time.now - Time.now.at_beginning_of_day)

    list = []
    phones = ["134", "135", "136", "137", "138", "139", "150", "151", "152", "158", "159", "182", "183", "184", "187", "188", "178", "130", "131", "132", "155", "156", "185", "186", "180", "181", "189", "133", "153", "177"]
    list += ChestRecordTmp.where("mobile <> ''").order(updated_at: :desc).limit(10).map{|x| {mobile: x["mobile"][0..2] + "****" + x["mobile"][7..10],  value: ChestPrize.get_prizes_by_ids(x.chest_prize_ids).select{|chest_prize| chest_prize["prize_type"] == 9 }.first["num"]}}

    (20 - list.size).times do
      list << {mobile: "#{phones.sample}#{'%08d' % rand(99999999)}", value:  rand(8) + 3 }
    end

    list.each do |x|
      x[:mobile] = x[:mobile][0..2] + "****" + x[:mobile][7..10]
    end

    last_user_count = Rails.cache.fetch("last_user_count:#{Date.today.to_s}", expires_in: 3600 * 24){
      147
    }.to_i
    last_user_count_time = Rails.cache.fetch("last_user_count_time:#{Date.today.to_s}", expires_in: 3600 * 24){
      0
    }.to_i
    user_count = last_user_count + (rand(3) + 1) * (Time.now - Time.now.at_beginning_of_day - last_user_count_time ).to_i

    Rails.cache.write("last_user_count:#{Date.today.to_s}", user_count)
    Rails.cache.write("last_user_count_time:#{Date.today.to_s}", Time.now - Time.now.at_beginning_of_day)

    chest_box = ChestBox.current(6)
    if chest_box.blank? || $redis.llen(chest_box.jd_card_redis_key(1)).to_i == 0
      left_count = 0
    end
    res = {
      last_count: last_count,
      left_count: left_count,
      user_count: user_count,
      list: list
    }
    render json: {"execResult"=>true, "execMsg"=>"", "execData"=>res, "execDatas"=>[], "execErrCode"=>"200"}
  end

  #H5推广页开宝箱接口
  def h5_landing_box
    if session[:chest_record_tmp_id] && (chest_record_tmp = ChestRecordTmp.where(id: session[:chest_record_tmp_id]).where("created_at > ?", Time.now - 600 ).first)
      chest_prize_ids = chest_record_tmp.chest_prize_ids
      chest_box = chest_record_tmp.chest_box
      render json: {"execResult" => true, "execMsg" => "抽奖成功", "execData" => {chest_record_tmp: chest_record_tmp,
        chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }}, "execDatas" => [], "execErrCode" => "200"}.with_indifferent_access
    else
      chest_box = ChestBox.current(6)
      if chest_box
        res = chest_box.draw_jd_card(params[:type].to_i)
        session[:chest_record_tmp_id] = res["execData"]["chest_record_tmp"]["id"] if res["execResult"] == true
        render json: res
      else
        render json:{"execResult"=>false, "execMsg"=>"奖品已经抢完", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
      end
    end
  end

  #抽奖结果绑定手机号
  def h5_landing_binding_mobile
    if(params[:mobile] && !params[:code].blank? && Rails.cache.read("mobile_code:#{params[:mobile]}").to_s == params[:code] )
      Rails.logger.info("*"*100)
      Rails.logger.info(session[:chest_record_tmp_id])
      if(params[:chest_record_tmp_id] && params[:chest_record_tmp_id].to_s == session[:chest_record_tmp_id].to_s && params[:mobile] && ChestRecordTmp.where(mobile: params[:mobile]).blank? && (chest_record_tmp = ChestRecordTmp.where(id: params[:chest_record_tmp_id], status: 0).first))
        if Time.now - chest_record_tmp.created_at < 600 && chest_record_tmp.mobile.blank?
          chest_record_tmp.update(mobile: params[:mobile])
          render json:{"execResult"=>true, "execMsg"=>"绑定成功", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"200"}
        else
          render json:{"execResult"=>false, "execMsg"=>"奖品已经过期", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
        end
      else
        render json:{"execResult"=>false, "execMsg"=>"奖品已经抢完", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"501"}
      end
    else
      render json:{"execResult"=>false, "execMsg"=>"验证码不正确", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"502"}
    end
  end


  def index
    treasure_total_amount = 0
    free_treasure_amount = 4
    if current_user
      treasure_total_amount = current_user.account_ticket.treasure_total_amount
      free_treasure_amount = current_user.account_ticket.free_treasure_amount
    end
    render json: {"execResult" => true, "execMsg" => "", "execData" => {current_boxs: ChestBox.current_boxs, treasure_total_amount: treasure_total_amount, free_treasure_amount: free_treasure_amount}, "execDatas" => [], "execErrCode" => "200"}
  end

  def prizes
    chest_box = ChestBox.find(params[:id])
    if chest_box
      if [1,2,3,4].include? chest_box.chest_type
        chest_prizes = chest_box.chest_prizes
        render json: {"execResult" => true, "execMsg" => "", "execData" => {chest_prizes: chest_prizes.select { |x| x.id != chest_box.big_prize_id }.as_json.map { |x| x.merge({level: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level, left_count: chest_box.left_prize_count(x["id"]), cbp_prize_type: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.prize_type, lottery_num: ChestRecordItem.prize_lottery_num(chest_box.id, x["id"])}) }, big_chest_prize: chest_prizes.select { |x| x.id == chest_box.big_prize_id }.first}, "execDatas" => [], "execErrCode" => "200"}
      else
        chest_prizes = []

        chest_box.chest_prizes.select{ |x| x.id != chest_box.big_prize_id }.as_json.each do |x|
          cbs = chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first
          chest_prizes << x.merge({
            level: cbs&.level,
            left_count: cbs&.left_num.to_i,
            cbp_prize_type: cbs&.prize_type,
            lottery_num: cbs&.base_num.to_i - cbs&.left_num.to_i,
          })
        end

        render json: {
          "execResult" => true, "execMsg" => "",
          "execData" => {
            # chest_prizes: chest_prizes.select { |x| x.id != chest_box.big_prize_id }.as_json.map { |x| x.merge({level: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level, left_count: 1, cbp_prize_type: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.prize_type, lottery_num: 1}) },
            chest_prizes: chest_prizes,
            big_chest_prize: chest_box.chest_prizes.select { |x| x.id == chest_box.big_prize_id }.first
            }, "execDatas" => [], "execErrCode" => "200"}
      end
    else
      render json: {"execResult" => false, "execMsg" => "宝箱不存在", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end
  end

  def left_prize_count
    chest_box = ChestBox.where(id: params[:id]).first
    if chest_box
      left_prizes_count = chest_box.left_prizes_count
      render json: {"execResult" => true, "execMsg" => "", "execData" => {left_prizes_count: left_prizes_count}, "execDatas" => [], "execErrCode" => "200"}
    else
      render json: {"execResult" => true, "execMsg" => "宝箱已开完", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end
  end

  def notice
    chest_records = ChestRecord.includes(:user).order(id: :desc).ransack({prize_type_in: [1, 7]}).result.page(1).per(10)
    chest_prize_ids = chest_records.map { |x| x.chest_prize_ids.split(",") }.flatten.uniq
    if chest_prize_ids.size > 0
      chest_prizes = ChestPrize.select(:id, :name, :prize_type, :thumbnail, :price).where(id: chest_prize_ids)
    end

    @chest_records = []
    chest_records.each do |chest_record|
      ids = chest_record.chest_prize_ids.split(",").map(&:to_i)
      @chest_records << chest_record.as_json(
          {only: [:id, :created_at, :chest_box_id],
           include: {
               user: {
                   only: [:id, :nick_name, :head_url, :login_name]
               }
           }
          }).merge(chest_prizes: chest_prizes.select { |x| ids.include?(x.id) && (x.prize_type == 1 || x.prize_type == 7) }, time: cal_time(chest_record.created_at))
    end

    render json: {"execResult" => true, "execMsg" => "", "execData" => {chest_records: @chest_records}, "execDatas" => [], "execErrCode" => "200"}
  end

  def current_notice
    chest_records = ChestRecord.includes(:user).order(id: :desc).ransack(params[:q]).result.page(1).per(10)
    chest_prize_ids = chest_records.map { |x| x.chest_prize_ids.split(",") }.flatten.uniq
    if chest_prize_ids.size > 0
      chest_prizes = ChestPrize.select(:id, :name, :prize_type, :thumbnail, :price).where(id: chest_prize_ids)
    end

    @chest_records = []
    chest_records.each do |chest_record|
      ids = chest_record.chest_prize_ids.split(",").map(&:to_i)
      @chest_records << chest_record.as_json(
          {only: [:id, :created_at, :chest_box_id],
           include: {
               user: {
                   only: [:id, :nick_name, :head_url]
               }
           }
          }).merge(chest_prizes: chest_prizes.select { |x| ids.include?(x.id) }.sort { |x, y| y.price <=> x.price }, time: cal_time(chest_record.created_at))
    end

    render json: {"execResult" => true, "execMsg" => "", "execData" => {chest_records: @chest_records}, "execDatas" => [], "execErrCode" => "200"}
  end

  def cal_time(time)
    case res = Time.now - time
      when 0...60
        "#{res.to_i}秒"
      when 60...3600
        "#{(res / 60).to_i}分钟"
      else
        "#{[(res / 3600).to_i, 24].min}小时"
    end
  end

  def draw
    chest_box = ChestBox.find(params[:id])
    if chest_box
      res = chest_box.draw(@current_user, request)
      render json: res
    else
      render json: {"execResult" => false, "execMsg" => "当前没有可开启宝箱", "execData" => {}, "execDatas" => [], "execErrCode" => "1404"}
    end
  end

  def draw_cash
    chest_box = ChestBox.find(params[:id])
    if chest_box
      res = chest_box.draw_cash(@current_user)
      render json: res
    else
      render json: {"execResult" => false, "execMsg" => "当前没有可开启宝箱", "execData" => {}, "execDatas" => [], "execErrCode" => "1404"}
    end
  end

  def draw_cash_index
    current_boxs = Rails.cache.fetch("chest_boxs_current_cash_boxs", expires_in: 10) {
      res = {}
      [7,8].each do |key|
        if chest_box = ChestBox.current(key)
          res[key] = {chest_box: chest_box.as_json.slice("id")}
        end
      end
      res.as_json
    }
    free_treasure_amount = 0
    if current_user
      free_treasure_amount = current_user.account_ticket.free_treasure_amount
    end

    render json: {"execResult" => true, "execMsg" => "", "execData" => {current_boxs: current_boxs, left_count: free_treasure_amount, total_count: InviteRelationship.where(invite_user_id: current_user.id).count, ensure_amount: (Setting.value("draw_cash_ensure_amount") || 1.5).to_f, register_amount: (Setting.value("draw_cash_register_amount") || 0.5).to_f , used_count: ChestRecord.joins("join chest_boxs on chest_boxs.id = chest_records.chest_box_id").where(user_id: current_user.id, "chest_boxs.chest_type" => [7, 8] ).count }, "execDatas" => [], "execErrCode" => "200"}
  end

  def exchange
  end

end
