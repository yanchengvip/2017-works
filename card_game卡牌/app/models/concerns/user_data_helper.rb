module UserDataHelper
  extend ActiveSupport::Concern
  module ClassMethods
    def user_info_csv_data params
      data_arr = []
      index = SYSTEMCONFIG[:es_table_prefix] + "user"
      start_time = DateTime.parse(params[:create_time_begin]&.to_s).strftime('%Y-%m-%dT00:00:01.000Z').to_s if params[:create_time_begin].present?
      end_time = DateTime.parse(params[:create_time_end]&.to_s).strftime('%Y-%m-%dT23:59:59.000Z').to_s if params[:create_time_end].present?
      if params[:create_time_begin].present? && params[:create_time_end].present?
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :range => {:create_time =>{:gte => start_time,:lte => end_time}}
                },
                :size=>10000
            }
          })
      else
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :match_all => {}
                },
                :size=>10000
            }
          })
      end
      results = response["hits"]["hits"]
      results.each do |result|
        # '微积分当前余额','功勋当前余额','参加战役总场数','消耗能量总数','胜利战役总数',
        # '领奖总次数','兑换功勋总次数','兑换能量总次数'
        address = Address.where(:user_id => result["_source"]["id"]).active.order('create_time desc').first
        battle_winning_record = BattleWinningRecord.where(:user_id => result["_source"]["id"]).active.count
        battle_count = BattleUserRecord.where(:user_id => result["_source"]["id"]).active
        card_user_sum = CardUserOwn.where(:user_id => result["_source"]["id"]).active.sum(:card_num)
          data_arr << [
            DateTime.parse(result["_source"]["create_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s,
            result["_source"]["opsrc"],
            result["_source"]["client"],
            result["_source"]["id"],
            result["_source"]["nick_name"],
            result["_source"]["name"],
            User::SEX[result["_source"]["sex"]],
            result["_source"]["mobile"],
            result["_source"]["email"],
            result["_source"]["id_number"],
            address&.detailed_address,
            result["_source"]["login_ip"],
            DateTime.parse(result["_source"]["login_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s,
            battle_count.count,
            battle_count.sum(:card_num),
            battle_winning_record
          ]
      end
      return data_arr
    end
    #用户卡牌使用统计
    def user_card_use_info_csv params
      data_arr = []
      index = SYSTEMCONFIG[:es_table_prefix] + "card_user_record"
      start_time = DateTime.parse(params[:create_time_begin]&.to_s).strftime('%Y-%m-%dT00:00:01.000Z').to_s if params[:create_time_begin].present?
      end_time = DateTime.parse(params[:create_time_end]&.to_s).strftime('%Y-%m-%dT23:59:59.000Z').to_s if params[:create_time_end].present?
      if params[:create_time_begin].present? && params[:create_time_end].present?
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :range => {:create_time =>{:gte => start_time,:lte => end_time}}
                },
                :size=>10000
            }
          })
      else
        response = $es_client.search ({
            :index => index, :body=> {
                :query => {
                  :match_all => {}
                },
                :size=>10000
            }
          })
      end
      results = response["hits"]["hits"]
      results.each do |result|
        battle = Battle.find(result["_source"]["battle_id"].to_i) if result["_source"]["battle_id"].present?
        user = User.find(result["_source"]["user_id"].to_i) if result["_source"]["user_id"].present?
        data_arr << [
          result["_source"]["user_id"],
          user&.nick_name,
          result["_source"]["be_user_id"],
          result["_source"]["card_id"],
          result["_source"]["battle_id"],
          battle&.name,
          result["_source"]["use_num"],
          result["_source"]["use_round"],
          result["_source"]["current_price"],
          CardUserRecord::ConsumeType[result["_source"]["consume_type"]],
          CardUserRecord::GainType[result["_source"]["gain_type"]],
          DateTime.parse(result["_source"]["create_time"]).localtime.strftime("%Y-%m-%d %H:%M:%S").to_s
        ]
      end
      return data_arr
    end



    #用户充值微积分
    def account_change params
      data_arr = []
      if params[:create_time_begin].present? && params[:create_time_end].present?
        account_logs = AccountLog.active.where('create_time >= ? and create_time <= ?',params[:create_time_begin],params[:create_time_end])
      else
        account_logs = AccountLog.active
      end

      account_logs.each do |log|
        data_arr << [
          log.user_id,
          AccountLog::Channel[log.channel],
          AccountLog::ChangeType[log.change_type],
          log.change_amount,
          log.trade_no,
          log.attach,
          log.ip,
          log.create_time.strftime('%Y-%m-%d %H:%M:%S')
        ]
      end
      return data_arr
    end





  end
end
