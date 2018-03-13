class Api::SignRecordsController < Api::ApplicationController


  def setting_list
    @sgs = SignGiftSetting.order(running_days: :asc).active
    yesterday_sign = SignRecord.where(user_id: current_user.id, sign_date: (Time.now-1.days).strftime('%Y-%m-%d')).active.first
    @running_days = yesterday_sign.present? ? (yesterday_sign.running_days + 1) : 1
    max_days = SignGiftSetting.active.maximum('running_days')
    #超过最大天数后重置
    @running_days = 1 if max_days < @running_days
  end


  #用户连续登录奖励记录 17600117650
  def sign_records
    begin
      yesterday_sign = SignRecord.where(user_id: current_user.id, sign_date: (Time.now-1.days).strftime('%Y-%m-%d')).active.first
      today_sign = SignRecord.where(user_id: current_user.id, sign_date: Time.now.strftime('%Y-%m-%d')).active
      if today_sign.present?
        render json: {execResult: true, execMsg: '今日用户已登录领取', execErrCode: 401, execDatas: []} and return
      end
      running_days = yesterday_sign.present? ? (yesterday_sign.running_days + 1) : 1
      max_days = SignGiftSetting.active.maximum('running_days')
      #超过最大天数后重置
      if max_days < running_days
        running_days = 1
      end
      sgs = SignGiftSetting.where(running_days: running_days).active.first
      if sgs.nil?
        render json: {execResult: true, execMsg: "没有配置第#{running_days}天的奖励", execErrCode: 402, execDatas: []} and return
      end
      account_ticket = current_user.account_ticket
      account_ticket.with_lock do
        SignRecord.create!(user_id: current_user.id, sign_date: Time.now.strftime('%Y-%m-%d'),
                           running_days: running_days, amount: sgs&.amount, gift_type: sgs&.gift_type)

        #免费宝箱符
        if sgs.gift_type == 1 && sgs.amount >=1
          account_ticket.update!(free_treasure_amount: current_user.account_ticket.free_treasure_amount + sgs.amount)
          current_user.account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["免费宝箱宝符"], fund: sgs.amount, wealth_type: 2, trad_type: AccountTicketDetail::TRADTYPE["登录奖励"], create_time: Time.now)
        end
        #付费宝箱符
        if sgs.gift_type == 2 && sgs.amount >= 1
          account_ticket.update!(treasure_total_amount: current_user.account_ticket.treasure_total_amount + sgs.amount)
          current_user.account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["宝箱宝符"], fund: sgs.amount, wealth_type: 2, trad_type: AccountTicketDetail::TRADTYPE["登录奖励"], create_time: Time.now)
        end
        render json: {execResult: true, execMsg: "连续登录第#{running_days}天", execErrCode: 200,
                      execDatas: {gift_type: sgs.gift_type, amount: sgs&.amount}} and return

      end

    rescue Exception => e
      render json: {execResult: true, execMsg: "网络异常，稍后重试", execErrCode: 403, execDatas: {error: e.as_json}} and return
    end

  end


end