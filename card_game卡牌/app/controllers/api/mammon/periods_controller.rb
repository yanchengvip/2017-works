class Api::Mammon::PeriodsController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:is_open]
  def is_open
    render json:  {
          execResult: true,
          execMsg: '',
          execErrCode: "200",
          execDatas: [],
          execData: {wealth_god_bless_here: Setting.value("wealth_god_bless_here").to_i}
      }
  end

  def index
    period = Mammon::Period.current
    Mammon::UserCard.add_card_to_user(current_user, period)
    if period.blank?
      render json: {
          execResult: true,
          execMsg: '没有数据！',
          execErrCode: 500,
          execDatas: []
      }
    else
      render json: {
          "execResult": true,
          "execMsg": "",
          "execData": {
              'period': period.as_json.except('left_amount', 'left_code_count'),
              'is_first_login': period.first_login?(current_user),
              'user_codes_count': period.user_codes(current_user)&.size,
              'user_total_amount': AccountTicketBalanceDetail.user_mammon_total_amount(current_user.id),
              'invite_prizes': period.invite_prizes,
              'share_copy': Copy.copy_content(24),
              'user_id': current_user.id,
              'count_down': (period.end_time - Time.now - 10),
              'prev_id': Mammon::Period.previous&.id,
              'left_code_count': period.llen_pop_code + $redis.smembers(period.box_redis_keys).size,
              'user_card_count': period.user_card_count(current_user.id)
          },
          "execDatas": [],
          "execErrCode": "200"
      }
    end
  end

  def welfare
    period = Mammon::Period.current
    if period.blank?
      render json: {
          execResult: true,
          execMsg: '没有数据！',
          execErrCode: 500,
          execDatas: []
      }
    else
      render json: {
          "execResult": true,
          "execMsg": "",
          "execData": {
              "current_period": {
                  'end_time': period.end_time,
                  'period_items': period.prize_items
              },
              'award_rules': Setting.value('mammon_prize_rule') || '开奖规则',
              'user_count': period.user_count, #已有用户数量
              'total_gain': period.total_gain #累计获得
          },
          "execDatas": [],
          "execErrCode": "200"
      }
    end
  end

  #开奖信息
  def open_info
    period_id = params[:period_id]
    res = Rails.cache.fetch("period_open_info:#{period_id}", expires_in: 10) {
      period = Mammon::Period.find(params[:period_id])
      {period_id: period_id, code: period.code, status: period.status}
    }
    render json: {
        execResult: true,
        execMsg: '开奖信息',
        execErrCode: 200,
        execData: res
    }
  end

  #用户获奖信息
  def user_win_info
    begin
      pre_period = Mammon::Period.previous #最近一次开奖的期次
      period_id = pre_period&.id
      #判断用户是否已调用此接口，用户只能调用一次
      is_look = $redis.sadd("period:#{period_id}:look_result_user_ids", [current_user.id])
      if is_look == 0
        render json: {execResult: true, execMsg: '用户已查看过中奖信息', execErrCode: 401,
                      execData: {msg: '用户只能查看一次'}} and return
      end

      awards = []
      total_amount, l0, l1, l2, l3 = 0, 0, 0, 0, 0
      user_winnings = current_user.mammon_user_winnings.where(period_id: period_id)
      user_winnings.each do |w|
        total_amount += w.amount
        case w.prize_num
          when 0;
            l0 += 1
          when 1;
            l1 += 1
          when 2;
            l2 += 1
          when 3;
            l3 += 1
        end
        awards.push({period_id: period_id, code: w.code, amount: w.amount, prize_num: w.prize_num,
                     created_at: w.created_at.present? ? w.created_at.strftime("%m月%d日") : ''})
      end
      render json: {execResult: true, execMsg: '用户中奖结果', execErrCode: 200,
                    execData: {total_amount: total_amount, code: pre_period.code, awards_num: {l0: l0, l1: l1, l2: l2, l3: l3}, awards: awards, }
      } and return
    rescue Exception => e
      render json: {execResult: true, execMsg: '网络异常，稍后重试', execErrCode: 400, execData: {error: e.as_json}}
    end
  end

end
