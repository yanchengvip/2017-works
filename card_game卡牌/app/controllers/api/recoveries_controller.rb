class Api::RecoveriesController < Api::ApplicationController
  skip_before_action :authenticate_user, only: []
  #抢兑列表页
  def index
    recoveries = Recovery.includes(:rule_recover_history_prices, :chest_prize).where(day: Date.today.to_s, status: 0, is_rule: false).order(sort_index: :desc).as_json(Recovery.xml_options).map{|x| x.merge(today_total_count:  RecoveryItem.select(:id,:count,:recovery_id).active.where(user_id: current_user.id, recovery_id: x["id"]).sum(:count) )}
    recoveries.each do |r|
      if r["time_begin"] > Time.now
        r["status"] = 101
      elsif r["time_end"] < Time.now
        r["status"] = 102
      end
    end

    render json: {"execResult" => true, "execMsg" => "", "execData" => {
        recoveries: recoveries,
    }, "execDatas" => [], "execErrCode" => "200"}
  end

  def get_yesterday_recovery
    # items = RecoveryItem.includes(:recovery).where(user_id: current_user.id).where(day: Date.yesterday.to_s)
    # total = 0
    # if items.count > 0
    #   items.each do |item|
    #     total += item.recovery.rule_recover_history_prices.where(day: Date.yesterday.to_s).first&.price.to_f * item.count
    #   end
    # end
    day = ""
    if Rails.cache.read("get_yesterday_recovery:#{Date.today.to_s}:#{current_user.id}")
      total = 0

    else

      detail = AccountTicketBalanceDetail.where(trad_type: 3, user_id: current_user.id).order(created_at: :desc).first
      total = 0
      if detail
        total = AccountTicketBalanceDetail.where(trad_type: 3, user_id: current_user.id).where("created_at > ? and created_at < ?", detail.created_at.at_beginning_of_day, detail.created_at.at_end_of_day).sum(:fund)
        day = detail.created_at.to_date.to_s
      end
      Rails.cache.write("get_yesterday_recovery:#{Date.today.to_s}:#{current_user.id}", total, expires_in: 24 * 3600)
    end
    render json: {"execResult" => true, "execMsg" => "", "execData" => {
        total: total, day: day
    }, "execDatas" => [], "execErrCode" => "200"}
  end

  #用户可兑换奖品数量
  def prize_count
    unless params[:chest_prize_type].blank?
      # count = ChestRecordItem.joins("join chest_records on chest_records.id = chest_record_id").where("chest_records.user_id = ? and chest_record_items.prize_type = ? and is_recovery = false", @current_user.id, params[:chest_prize_type]).count
      count = ChestRecordItem.where("user_id = ? and prize_type = ? and is_recovery = false", @current_user.id, params[:chest_prize_type]).count

      render json: {"execResult" => true, "execMsg" => "", "execData" => {
          count: count,
      }, "execDatas" => [], "execErrCode" => "200"}
    else
      render json: {"execResult" => false, "execMsg" => "缺少奖品参数", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end
  end

  #兑换现金
  def exchange_cash
    if !params[:chest_prize_type].blank? && !params[:recovery_id].blank? && !params[:count].blank? && params[:count].to_i > 0 && (recovery = Recovery.where(id: params[:recovery_id], is_rule: false, status: 0).first) && recovery.chest_prize_type == params[:chest_prize_type].to_i && recovery.time_begin < Time.now && recovery.time_end > Time.now
      params[:count] = params[:count].to_i
      params[:chest_prize_type] = params[:chest_prize_type].to_i
      recovery.with_lock do
        # items = ChestRecordItem.joins("join chest_records on chest_records.id = chest_record_id").where("chest_records.user_id = ? and chest_record_items.prize_type = ? and is_recovery = false", @current_user.id, params[:chest_prize_type]).limit(params[:count]).lock!
        items = ChestRecordItem.where("user_id = ? and prize_type = ? and is_recovery = false", @current_user.id, params[:chest_prize_type]).limit(params[:count]).lock!
        if items.count == params[:count]
          items.update_all(is_recovery: true)
          MsgRecord.apiClient('/card-service-web/h5/recoveryItems/recycleRecovery', {userId: current_user.id})
          recovery.recovery_items.create!(chest_prize_type: params[:chest_prize_type], user_id: @current_user.id, count: params[:count], chest_record_item_ids: items.pluck(:id).join(","), day: Date.today.to_s)
          recovery.update!(total_count: recovery.total_count + params[:count])
          render json: {"execResult" => true, "execMsg" => "", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
        else
          render json: {"execResult" => false, "execMsg" => "可兑换奖品数量不足", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
        end
      end
    else
      render json: {"execResult" => false, "execMsg" => "今日道具回收已结束，请明日再来！", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end
  end


  #销毁记录
  def recovery_items
    ris = RecoveryItem.select(:id,:count,:recovery_id,:created_at).active.order(created_at: :desc).where(user_id: current_user.id, recovery_id: params[:recovery_id])
    render json: {"execResult" => true, "execMsg" => "", "execData" => {}, "execDatas" => ris.as_json.map{|x| x.merge!({created_at: x['created_at'].strftime('%Y-%m-%d %H:%M')})}, "execErrCode" => "200"}
  end
end
