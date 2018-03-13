# statis
require 'csv'
class StatisController < ApplicationController
  authorize_resource :class => false,:only => [:index,:balance,:energy,:glory,:score,:channel,
                                               :activy,:game,:recharge,:exchange]
  # before_action :init_params_search
  before_action :side_menus8

  def mammon
    params[:start_time] ||= Date.today.to_s
    params[:start_time] = (params[:start_time].to_date - 1).to_s + ' 21:00:00'
    data = {}
    data[:login_count] = UserLoginRecord.select("DISTINCT user_id").where("created_at > ? and created_at < ?", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:invite_user_count] = InviteRelationship.select("DISTINCT invite_user_id").where("create_time > ? and create_time < ? and flag = 0", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:cover_invite_user_count] = InviteRelationship.select("DISTINCT cover_invite_user_id").where("create_time > ? and create_time < ? and flag = 0", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:invite_codes_count] = Mammon::UserCode.where("created_at > ? and created_at < ? and source_type = 4", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).sum(:count)
    data[:have_code_user_count] = Mammon::UserCode.select("DISTINCT user_id").where("created_at > ? and created_at < ?", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:box_code_count] = Mammon::UserCode.where("created_at > ? and created_at < ? and source_type = 5",  Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).sum(:count)
    data[:red_package_user_count] = Promotion::RedPackageItem.select("DISTINCT user_id").where("created_at > ? and created_at < ? ", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:recovery_user_count] = RecoveryItem.select("DISTINCT user_id").where("created_at > ? and created_at < ? ", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).count
    data[:recovery_count] = RecoveryItem.where("created_at > ? and created_at < ? ", Time.parse(params[:start_time]), Time.parse(params[:start_time]) + 24 * 3600).sum(:count)

    data[:cash_user_count] = AccountTicket.select('id, balance, withdrawals').where("withdrawals > 0 or balance > 0").size
    data[:withdrawals_user_count] = AccountTicket.select('id, withdrawals').where("withdrawals > 0").size
    data[:amount_payable] = AccountTicket.select('id,`balance`,`withdrawals`').sum('balance+withdrawals').to_f
    data[:real_pay_amount] = AccountTicket.select('id,withdrawals').sum('withdrawals').to_f
    data[:left_amount_payable] = AccountTicket.select('id,balance').sum('balance').to_f
    data[:less_than_5_count] = AccountTicket.select('id,balance').where("balance < 5 and balance > 0").size
    data[:less_than_5_amount] = AccountTicket.select('id,balance').where("balance < 5 and balance > 0").sum('balance').to_f
    data[:more_than_5_count] = AccountTicket.select('id,balance').where("balance >= 5").size
    data[:more_than_5_amount] = AccountTicket.select('id,balance').where("balance >= 5").sum('balance').to_f

    data[:cash_from] = AccountTicketBalanceDetail.select('id,fund,trad_type').active.where(trad_type: [2,3,4,6,7])
    data[:invite_times] = InviteRelationship.select("count(*) as num").active.group(:invite_user_id)

    @res = [data]
  end

  def pv_count
    params[:start_time] = params[:start_time] || (Date.today - 1).to_s
    params[:end_time] = params[:end_time] || (Date.today).to_s
    response = $es_client.search ({
        :index => "zbqibing_logstash", :body=> {
        "size": 0,
        "query": {
          "bool": {
            "must": [
              {
                "terms": {
                  "url.keyword": ["http://www.zbqibing.com/box/emptybox", "http://www.zbqibing.com/box/jdbox", "http://www.zbqibing.com/box/wmbox", "http://www.zbqibing.com/box/getPrize"
                  ]
                }
              },
              {
                "range": {
                  "@timestamp": {
                    "gte": params[:start_time],
                    "lte": params[:end_time]
                  }
                }
              }
            ]

          }
        },

        "aggs": {
          "from": {
            "terms": {
              "field": "ad_from.keyword",
              "size": 1000
            },
            "aggs": {
              "url": {
                "terms": {
                  "field": "url.keyword",
                  "size": 100
                }
              }
            }
          }
        }
      }
    })
    @data = response["aggregations"]["from"]["buckets"]

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道ID 宝箱首页 填写手机号页 下载页)
        @data.each do |source|
          source = source.with_indifferent_access
          csv << [source[:key],
                  (s = source[:url][:buckets].select{|x| x[:key] == "http://www.zbqibing.com/box/wmbox"}.first) ? s[:doc_count] : 0,
                  (s = source[:url][:buckets].select{|x| x[:key] == "http://www.zbqibing.com/box/jdbox"}.first) ? s[:doc_count] : 0,
                  (s = source[:url][:buckets].select{|x| x[:key] == "http://www.zbqibing.com/box/getPrize"}.first) ? s[:doc_count] : 0
              ]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def app_box_count
    params[:start_time] = params[:start_time] || (Date.today - 1).to_s
    params[:end_time] = params[:end_time] || (Date.today).to_s
    tmps = ChestRecordTmp.where(chest_box_chest_type: 5, status: [0, -1, 1]).where("created_at > ? and created_at < ?", Time.parse(params[:start_time]).at_beginning_of_day , Time.parse(params[:end_time]).end_of_day).group_by{|x| x.created_at.to_date.to_s}
    @data = {}
    tmps.each do |k, v|
      @data[k] = {"open_box_count" => v.size}
    end
    tmps = ChestRecordTmp.where(chest_box_chest_type: 5, status: 1).where("created_at > ? and created_at < ?", Time.parse(params[:start_time]).at_beginning_of_day , Time.parse(params[:end_time]).end_of_day).group_by{|x| x.created_at.to_date.to_s}
    tmps.each do |k, v|
      @data[k]["accept_prize"]  = v.size
    end

    response = $es_client.search ({
      :index => "zbqibing_logstash",
      :body=>
        {
          "size": 0,
          "query": {
            "bool": {
              "must": [
                {
                  "range": {
                    "@timestamp": {
                      "gte": params[:start_time],
                      "lte": params[:end_time]
                    }
                  }
                },
                {
                  "terms": {
                    "url.keyword": [
                      "http://www.zbqibing.com/box/openOneBox"
                    ]
                  }
                }
              ]
            }
          },
          "aggs": {
            "day": {
              "date_histogram": {
                "field": "@timestamp",
                "interval": "day",
                "time_zone": "+08:00"
              }
            }
          }
        }
      })
    response["aggregations"]["day"]["buckets"].each do |day|
      @data[Date.parse(day["key_as_string"]).to_s] ||= {}
      @data[Date.parse(day["key_as_string"]).to_s]["pv_count"] = day["doc_count"]
    end

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(日期 打开数 开宝箱数 领奖次数 )
        @data.each do |day, data|
          csv << [day, data["pv_count"] || 0, data["open_box_count"] || 0, data["accept_prize"] || 0]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end


  def index
    @q = User.active.ransack(params[:q])
    @total = @q.result&.count
    @users = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道编号 手机号 注册ID 注册版本 注册时间 用户昵称 绑定微信号 手机型号 默认地址)
        @q.result.each do |user|
          csv << [user.opsrc, user.mobile, user.id, "无", user.create_time&.strftime("%Y-%m-%d %H:%M"), user.nick_name, "无", "无", "无"]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def energy
    params[:q][:type_eq] = 2
    if params[:mobile].blank?
      @q = AccountTicketDetail.includes(:user).active.ransack(params[:q])
    else
      @q = AccountTicketDetail.includes(:user).where("user.mobile": params[:mobile]).active.ransack(params[:q])
    end
    @account_ticket_details = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 交易时间 交易数量 交易状态 交易类型)
        @q.result.each do |account_ticket_detail|
          csv << [account_ticket_detail.user_id, account_ticket_detail.user&.mobile, account_ticket_detail.create_time&.strftime("%Y-%m-%d %H:%M"), account_ticket_detail.fund, account_ticket_detail.wealth_type, account_ticket_detail.trad_type]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def glory
    if params[:mobile].blank?
      @q = MicroTicketRecord.includes(:user).active.ransack(params[:q])
    else
      @q = MicroTicketRecord.includes(:user).where("user.mobile": params[:mobile]).active.ransack(params[:q])
    end
    # @q = AccountTicketDetail.active.ransack(params[:q])
    @micro_ticket_records = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 交易时间 交易数量 交易状态 渠道)
        @q.result.each do |micro_ticket_record|
          csv << [micro_ticket_record.user_id, micro_ticket_record.user&.mobile, micro_ticket_record.create_at&.strftime("%Y-%m-%d %H:%M"), micro_ticket_record.change_amount, micro_ticket_record.change_type, micro_ticket_record.channel]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def score
    # @q = AccountLog.active.includes(:user_third_party).ransack(params[:q])
    if params[:mobile].blank?
      # mobiles = User.page(params[:page]).per(15).pluck(:mobile)
      @q = AccountLog.active.includes(:user_third_party).where("user_id" => UserThirdParty.pluck(:user_id)).ransack(params[:q])
    else
      @q = AccountLog.active.includes(:user_third_party).where(
        "user_third_party.third_account" => params[:mobile]).ransack(params[:q])
    end
    @account_logs = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 交易时间 交易数量 交易状态 交易类型)
        @q.result.each do |account_log|
          csv << [account_log.user_third_party&.card_user&.id, account_log.user_third_party&.third_account, account_log.create_time&.strftime("%Y-%m-%d %H:%M"), account_log.change_amount, account_log.change_type, account_log.type]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def balance
    # @user_third_partys = UserThirdParty.active.select('user_id, third_account, type')
    # @accounts = Account.active.select('id, user_id, total_amount')
    # @q = AccountTicket.active.ransack(params[:q])
    # @account_tickets = @q.result.includes(:user).page(params[:page]).per(15)
    if !params[:mobile].blank?
      @q = AccountTicket.active.includes(:user).where("user.mobile" => params[:mobile]).ransack(params[:q])
    else
      @q = AccountTicket.active.includes(:user).ransack(params[:q])
    end
    @account_tickets = @q.result.page(params[:page]).per(15)
    @user_third_partys = UserThirdParty.includes(:account).active.select('user_id, third_account, type').where(third_account: @account_tickets.map { |a| a.user&.mobile })
    # binding.pry

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 能量余额 微积分余额 功勋余额 宝符余额)
        @q.result.each do |account_ticket|
          csv << [account_ticket.user_id, account_ticket.user&.mobile, account_ticket.energy_total_amount, @user_third_partys.find{|utp| utp.third_account == account_ticket.user&.mobile && utp.type == 3}&.account&.total_amount, account_ticket.micro_total_amount, account_ticket.treasure_total_amount]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def channel
    # users = User.active.pluck(:id, :opsrc, :create_time, :client)
    # @channels = users.group_by{|u| u.opsrc}
    @q = User.active.ransack(params[:q])
    @channels = @q.result.group_by{|u| u.opsrc}

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道名称 点击次数 下载次数 安卓注册用户数 IOS注册用户数)
        @q.result.each do |k, v|
          csv << [k || '字段内容为空', "无", "无", v.select{|i| i.client == 'android'}&.size, v.select{|i| i.client == 'ios'}&.size]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def activy
  end

  def game
    # if params[:mobile].blank? && params[:lucky_mobile].blank?
    #   @q = Game.includes(battle_user_records: [:user], battle_winning_record: [:user]).active.ransack(params[:q])
    #   @games = @q.result.page(params[:page]).per(15)
    # else
    #   if !params[:mobile].blank?
    #     user = User.where(mobile: params[:mobile]).first
    #     if user
    #       @q = Game.includes(battle_user_records: [:user], battle_winning_record: [:user]).where("id" => BattleUserRecord.where(user_id: user.id).pluck(:battle_id)).active.ransack(params[:q])
    #       @games = @q.result.page(params[:page]).per(15)
    #     else
    #       @games = []
    #     end
    #   else
    #     user = User.where(mobile: params[:lucky_mobile]).first
    #     if user
    #       @q = Game.includes(battle_user_records: [:user], battle_winning_record: [:user]).where("id" => BattleWinningRecord.where(user_id: user.id).pluck(:battle_id)).active.ransack(params[:q])
    #       @games = @q.result.page(params[:page]).per(15)
    #     else
    #       @games = []
    #     end
    #   end
    # end


    relation = Game.includes(battle_user_records: [:user], battle_winning_record: [:user]).joins(" join battle_user_record on battle_user_record.battle_id = game_battle_record.id").joins(" join user on user.id = battle_user_record.user_id")

    relation = relation.where("user.opsrc = ?",  params[:opsrc]) unless params[:opsrc].blank?

    relation = relation.where("user.login_name = ?",  params[:mobile]) unless params[:mobile].blank?
    relation = relation.where("user.login_name = ?",  params[:lucky_mobile]) unless params[:lucky_mobile].blank?

    @q = relation.active.ransack(params[:q])
    @games = @q.result.page(params[:page]).per(15)

    # .where("user.opsrc = '61'")


    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(赛场ID  开赛时间  赛场名称  参赛人数   获胜手机号 参赛手机号 渠道信息)
        @q.result.each do |game|
          csv << [game.id, game.create_time&.strftime("%Y-%m-%d %H:%M"), game.name, game.battle_user_records&.map(&:user_id)&.uniq&.size, game&.battle_winning_record&.user&.mobile, game.battle_user_records&.map{|x| x&.user&.mobile},  game.battle_user_records&.map{|x| x&.user&.opsrc} ].flatten
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  def recharge
    params[:q][:trad_type_eq] = 1
    params[:q][:wealth_type_eq] = 2
    # @q = AccountTicketDetail.active.ransack(params[:q])
    if params[:mobile].blank?
      @q = AccountTicketDetail.active.ransack(params[:q])
    else
      @q = AccountTicketDetail.includes(:user).where("user.mobile": params[:mobile]).active.ransack(params[:q])
    end
    @account_ticket_details = @q.result.page(params[:page]).per(15)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(用户ID 手机号 充值时间 充值额度 购买品类 变化类型 变化名称)
        @q.result.each do |account_ticket_detail|
          csv << [account_ticket_detail.user_id, account_ticket_detail.user&.mobile, account_ticket_detail.create_time&.strftime("%Y-%m-%d %H:%M"), account_ticket_detail.fund, account_ticket_detail.type, account_ticket_detail.wealth_type, account_ticket_detail.trad_type]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end


  end

  def exchange
    # @q = MallOrder.active.ransack(params[:q])
    if params[:mobile].blank?
      @q = MallOrder.active.ransack(params[:q])
    else
      @q = MallOrder.includes(:user).where("user.mobile": params[:mobile]).active.ransack(params[:q])
    end

    @mall_orders = @q.result.page(params[:page]).per(15)


    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(商品编号 兑换时间 兑换用户ID 手机号 微集分消耗 功勋消耗)
        @q.result.each do |mall_order|
          csv << [mall_order.mall_product_id, mall_order.created_at&.strftime("%Y-%m-%d %H:%M"), mall_order.user_id, mall_order.user&.mobile, mall_order.micro_score, mall_order.micro_ticket]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end
  #各个来源请求次数
  def request_source
    @sources = []
    @time = {start_time: params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : (Time.now - 1.days).to_time.strftime("%Y-%m-%d"), end_time: params[:end_time].present? ? params[:end_time].to_time.strftime("%Y-%m-%d") : Time.now.strftime("%Y-%m-%d")}
    results = Static.request_source @time
    results.each do |result|
      result[1]["buckets"].each do |re|
        num = 0
        num1 = 0
        number = 0 #Android
        number1 = 0
        re["phone"]["buckets"].each do |r|
          if r["key"].include?("Android")
            num += r["doc_count"].to_i
            number += r["x_forword_for"]["value"].to_i
          else
            num1 += r["doc_count"].to_i
            number1 += r["x_forword_for"]["value"].to_i
          end
        end
        @sources << {
          :key => re["key"],
          :doc_count => re["doc_count"],
          :Androiddoc_count => num,
          :phonedoc_count => num1,
          :Androidip_count => number,
          :iosip_count => number1
        }
      end
    end
    @sources

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道ID 首页访问数量 Android点击访问量 Android_ip点击访问量 iphone点击访问量 iphone_ip点击访问量)
        @sources.each do |source|
          csv << [source[:key], source[:doc_count], source[:Androiddoc_count], source[:Androidip_count], source[:phonedoc_count], source[:iosip_count]]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def request_source_day
    @sources = []
    @time = {start_time: params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : Time.now.to_time.strftime("%Y-%m-%d")}
    results = Static.request_source_day @time
    results.each do |result|
      result[1]["buckets"].each do |re|
        num = 0
        num1 = 0
        re["phone"]["buckets"].each do |r|
          if r["key"].include?("Android")
            num += r["doc_count"].to_i
          else
            num1 += r["doc_count"].to_i
          end
        end
        @sources << {
          :key => re["key"],
          :doc_count => re["doc_count"],
          :Androiddoc_count => num,
          :phonedoc_count => num1
        }
      end
    end
    @sources

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道ID 首页访问数量 Android点击访问量 iphone点击访问量)
        @sources.each do |source|
          csv << [source[:key], source[:doc_count], source[:Androiddoc_count], source[:phonedoc_count]]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  #下载
  def download_source
    @sources = []
    @time = {start_time: params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : (Time.now - 1.days).to_time.strftime("%Y-%m-%d"), end_time: params[:end_time].present? ? params[:end_time].to_time.strftime("%Y-%m-%d") : Time.now.strftime("%Y-%m-%d")}
    results = Static.download_source @time
    results.each do |result|
      result[1]["buckets"].each do |re|
        num = 0 #Android总下载次数
        number = 0 #Android ip总下载次数
        num1 = 0 #ios
        number1 = 0 #ios ip总下载次数
        re["phone"]["buckets"].each do |r|
          if r["key"] == "Android"
            num += r["doc_count"].to_i
            number += r["x_forword_for"]["value"].to_i
          elsif r["key"] == "ios"
            num1 += r["doc_count"].to_i
            number1 += r["x_forword_for"]["value"].to_i
          end
        end
        @sources << {
          :key => re["key"],
          :doc_count => re["doc_count"],
          :Androiddoc_count => num,
          :phonedoc_count => num1,
          :Androidip_count => number,
          :iosip_count => number1
        }
      end
    end
    @sources

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道ID 下载量 Android下载量 Android_ip下载量 phone下载量 ios_ip下载量)
        @sources.each do |source|
          csv << [source[:key], source[:doc_count], source[:Androiddoc_count], source[:Androidip_count], source[:phonedoc_count], source[:iosip_count]]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def download_source_day
    @sources = []
    @time = {start_time: params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : Time.now.to_time.strftime("%Y-%m-%d"), end_time: params[:start_time].present? ? params[:start_time].to_time.strftime("%Y-%m-%d") : Time.now.strftime("%Y-%m-%d")}
    results = Static.download_source_day @time
    results.each do |result|
      result[1]["buckets"].each do |re|
        num = 0
        num1 = 0
        re["phone"]["buckets"].each do |r|
          if r["key"].include?("Android")
            num += r["doc_count"].to_i
          else
            num1 += r["doc_count"].to_i
          end
        end
        @sources << {
          :key => re["key"],
          :doc_count => re["doc_count"],
          :Androiddoc_count => num,
          :phonedoc_count => num1
        }
      end
    end
    @sources

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(渠道ID 下载量 Android下载量 phone下载量)
        @sources.each do |source|
          csv << [source[:key], source[:doc_count], source[:Androiddoc_count], source[:phonedoc_count]]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def invite_count
    @res = InviteRelationship.active.select("invite_user_id, count(*) as num, user.id, user.opsrc, user.login_name").joins(" join user on invite_relationship.invite_user_id = user.id").where("invite_user_id <> ''").group(:invite_user_id).order('num desc')
    @res = @res&.select{|r| r.num >= params[:invite_num].to_i} if params[:invite_num]
    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(登录名 渠道编号 邀请人数)
        @res.each do |res|
          csv << [res.login_name, res.opsrc, res.num]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  def attack_record
    params[:start_time] ||= Date.today.to_s
    params[:end_time] ||= Date.tomorrow.to_s
    @res = Mammon::AttackRecord.active.select("mammon_attack_records.id as mar_id, from_user_id, to_user_id, period_id, codes, card_id, mammon_attack_records.created_at, mammon_periods.id, mammon_periods.num").joins(" join mammon_periods on period_id = mammon_periods.id").where("mammon_attack_records.created_at >= ? and mammon_attack_records.created_at <= ?", params[:start_time], params[:end_time]).includes(:card)
    @res_pages = @res.page(params[:page]).per(15)
    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(期次 攻击者id 被攻击者id 技能牌 获取号码)
        @res.each do |res|
          csv << [res.num, res.from_user_id, res.to_user_id, res.card.name, res.codes]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end

  def package_record
    @res = Promotion::RedPackageItem.active.select("red_package_id, count(user_id) as user_count").group(:red_package_id).order(red_package_id: :desc)
  end

end
