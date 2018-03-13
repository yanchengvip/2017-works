class Api::Mammon::InviteRecordsController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:get_rewarded, :invitation_registered]

  #获取奖励信息接口(邀请好友)
  def get_rewarded

    period = Mammon::Period.current
    if period
      money = $redis.get(period.redis_cash_keys).to_i
      # if money > 0 && period.llen_pop_code > 0 #有现金和号码
      #   render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 1, data: {money: period.invite_reward.to_i}}, "execDatas" => [], "execErrCode" => "200"}
      # elsif money <= 0 && period.llen_pop_code > 0  #有号码、没现金
      #   render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 2}, "execDatas" => [], "execErrCode" => "200"}
      # elsif money <= 0 && period.llen_pop_code <= 0 #没号码、没现金
      #   render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 3}, "execDatas" => [], "execErrCode" => "200"}
      # elsif money > 0 && period.llen_pop_code <= 0 #有现金、没号码
      #   render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 4, data: {money: period.invite_reward.to_i}}, "execDatas" => [], "execErrCode" => "200"}
      # end
      if  period.llen_pop_code > 0 #只送号码
        render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 5 }, "execDatas" => [], "execErrCode" => "200"}
      else
        render json: {"execResult" => true, "execMsg" => "", "execData" => {type: 3}, "execDatas" => [], "execErrCode" => "200"}
      end
    else
      render json: {"execResult" => false, "execMsg" => "财神活动未开启", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end

  end


  #邀请成功
  def invitation_successful
    period = Mammon::Period.current_give
    invitations = period.read_invite_data(current_user)
    money = $redis.get(period.redis_cash_keys).to_i > 0
    # Mammon::InviteRecord.select("sum(prize_count) as prize_count, prize_type").where(:user_id => current_user.id,:period_id => period.id).group(:prize_type)
    render json: {"execResult" => true, "execMsg" => "", "execData" => {invitations: invitations, money: money}, "execDatas" => [], "execErrCode" => "200"}
  end

  #用户邀请并被邀请者成功注册(java调用)
  def invitation_registered
    #现金  号码  卡牌
    period = Mammon::Period.current
    invite_relationship = InviteRelationship.where(:invite_user_id => params[:invite_id],:cover_invite_user_id => params[:invite_user_id], status: 0, flag: 0).lock!.first

    invite_flag = InviteRelationship.where(invite_user_id:  params[:invite_id], flag: 0).count <= (Setting.value("user_invite_money_count") || 50).to_i

    user = User.find(params[:invite_id]) #邀请者
    user_invite = User.find(params[:invite_user_id]) #被邀请者

    code_count = (Setting.value("invite_code_count") || 5).to_i

    if period && invite_relationship
      money = $redis.get(period.redis_cash_keys).to_i
      # begin
        ActiveRecord::Base.transaction do

          invite_relationship.update!(status: 1)
          first_result_hash = Hash.new
          #每日首位邀请奖励2张技能牌 暂时取消
          # if Mammon::InviteRecord.first_invite_reg params[:invite_id],period.id
          #   first_result_hash = Mammon::UserCard.first_day_card(user, period, 2) if invite_flag
          # end
          # if money > 0 && period.llen_pop_code > 0 #有现金和号码 送1元现金和1个号码
          #   #抽奖号码和技能牌的领取有效期为2小时
          #   [100,200].each do |t|
          #       Mammon::InviteRecord.create(:user_id => params[:invite_id],:invite_user_id => params[:invite_user_id],:period_id => period.id,:prize_type => t.to_s,:prize_count => 1) if invite_flag
          #   end
          #   flag = AccountTicketBalanceDetail.give_account_ticket params[:invite_id],params[:invite_user_id],period
          #   Mammon::UserCode.add_code( params[:invite_id],period, user, code_count)  if invite_flag
          #   if Time.now - invite_relationship.create_time < 2*3600
          #     Mammon::UserCode.add_code(params[:invite_user_id],period,user_invite, code_count)
          #   end
          #   period.incrby_invite_data(user, first_result_hash, code_count, flag ? 1 : 0) if invite_flag
          #   period.incrby_invite_data(user_invite, {}, code_count, 1, 0)
          #   render json: {"execResult" => true, "execMsg" => "恭喜您获得5个号码,#{period.invite_reward}元现金", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
          # elsif money <= 0 && period.llen_pop_code > 0  #有号码、没现金 送2张卡牌和1个号码

          #   Mammon::InviteRecord.create(:user_id => params[:invite_id],:invite_user_id => params[:invite_user_id],:period_id => period.id,:prize_type => "200",:prize_count => 1) if invite_flag
          #   result_hash = Mammon::UserCard.give_card(user,user_invite,period,2,invite_relationship.create_time, invite_flag)
          #   Mammon::UserCode.add_code(params[:invite_id],period,user, code_count) if invite_flag
          #   if Time.now - invite_relationship.create_time < 2*3600
          #     Mammon::UserCode.add_code(params[:invite_user_id],period,user_invite, code_count)
          #   end
          #   period.incrby_invite_data(user, Hash.sum(result_hash, first_result_hash), code_count, 0) if invite_flag
          #   period.incrby_invite_data(user_invite, result_hash, code_count, 0, 0)
          #   render json: {"execResult" => true, "execMsg" => "恭喜您获得2张技能牌，5个号码", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
          # elsif money <= 0 && period.llen_pop_code <= 0 #没号码、没现金 送2张卡牌
          #   result_hash = Mammon::UserCard.give_card(user,user_invite,period,2,invite_relationship.create_time, invite_flag)
          #   render json: {"execResult" => true, "execMsg" => "恭喜您获得2张技能牌", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
          #   period.incrby_invite_data(user, Hash.sum(result_hash, first_result_hash), 0, 0) if invite_flag
          #   period.incrby_invite_data(user_invite, result_hash, 0, 0, 0)
          # elsif money > 0 && period.llen_pop_code <= 0 #有现金、没号码 送1元现金和2张卡牌

          #   Mammon::InviteRecord.create(:user_id => params[:invite_id],:invite_user_id => params[:invite_user_id],:period_id => period.id,:prize_type => "100",:prize_count => 1) if invite_flag
          #   flag = AccountTicketBalanceDetail.give_account_ticket params[:invite_id],params[:invite_user_id],period
          #   result_hash = Mammon::UserCard.give_card(user,user_invite,period,2,invite_relationship.create_time, invite_flag)
          #   period.incrby_invite_data(user, Hash.sum(result_hash, first_result_hash), 0, flag ? 1 : 0) if invite_flag
          #   period.incrby_invite_data(user_invite, result_hash, 0, 1, 0)
          #   render json: {"execResult" => true, "execMsg" => "恭喜您获得2张技能牌,#{period.invite_reward}元现金", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
          # end

          if period.llen_pop_code > 0  #有号码、没现金 送2张卡牌和1个号码
            Mammon::UserCode.add_code(params[:invite_id],period,user, code_count) if invite_flag
            period.incrby_invite_data(user, {}, code_count, 0) if invite_flag

            if Time.now - invite_relationship.create_time < 2*3600
              Mammon::UserCode.add_code(params[:invite_user_id],period,user_invite, code_count)
              period.incrby_invite_data(user_invite, {}, code_count, 0, 0)
            end

            render json: {"execResult" => true, "execMsg" => "恭喜您获得2张技能牌，5个号码", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
          else  #没号码、没现金 送2张卡牌
            result_hash = Mammon::UserCard.give_card(user,user_invite,period,2,invite_relationship.create_time, invite_flag)
            render json: {"execResult" => true, "execMsg" => "恭喜您获得2张技能牌", "execData" => {}, "execDatas" => [], "execErrCode" => "200"}
            period.incrby_invite_data(user, result_hash, 0, 0) if invite_flag
            period.incrby_invite_data(user_invite, result_hash, 0, 0, 0)
          end
        end
      # rescue Exception => e
      #   render json: {"execResult" => false, "execMsg" => "", "execData" => {error: e.as_json}, "execDatas" => [], "execErrCode" => "500"}
      # end
    else
      render json: {"execResult" => false, "execMsg" => "财神活动未开启", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end

  end


end
