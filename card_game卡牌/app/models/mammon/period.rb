class Mammon::Period < ApplicationRecord
  has_many :period_items, -> { where(delete_flag: false) }
  has_many :user_winnings, -> { where(delete_flag: false) }
  has_many :attack_records, -> { where(delete_flag: false) }
  has_many :user_cards, -> { where(delete_flag: false) }
  STATUS = {0 => '未结算', 1 => '结算中', 2 => '已结算'}

  validates :num, uniqueness: {scope: :delete_flag, message: '期次不能重复'}
  validates_presence_of :num, :end_time
  belongs_to :red_package_rule, class_name: 'Promotion::RedPackageRule', foreign_key: 'red_package_rule_id'

  def self.send_jpush(title = "您获得2张财神技能牌！", content = "1万个财神号码快要发放完了，快去使用技能牌抢夺吧！")
    res = MsgRecord.push_msg(SYSTEMCONFIG['java_redis_url'], "/card-service-web/msg/sendPushMsg", {title: title, content: content})
  end


  #增加用户邀请的数据
  def incrby_invite_data(current_user, cards, code_count, cash, invite = 1)
    cards.each do |k, v|
      $redis.incrby("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:card_count:#{k}", v.to_i)
    end
    $redis.set("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:invite", invite)

    $redis.incrby("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:code_count", code_count.to_i)
    $redis.incrbyfloat("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:cash", cash)

    $redis.incrby("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:user_count", 1)

    $redis.expire("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:invite", 48 * 3600)

    $redis.expire("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:card_count", 48 * 3600)
    $redis.expire("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:code_count", 48 * 3600)
    $redis.expire("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:cash", 48 * 3600)
    $redis.expire("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:user_count", 48 * 3600)
  end

  #读取用户邀请的数据
  def read_invite_data(current_user)
    res = {
        code_count: $redis.get("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:code_count").to_i,
        cash: $redis.get("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:cash").to_f,
        user_count: $redis.get("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:user_count"),
        invited: $redis.get("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:invite"),
    }
    Mammon::Card::NUM.each do |k|
      res[k] = $redis.get("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:card_count:#{k}").to_i
      $redis.del("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:card_count:#{k}")
    end
    $redis.del("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:user_count")
    $redis.del("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:code_count")
    $redis.del("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:cash")
    $redis.del("incrby_invite_data:period:#{self.id}:user:#{current_user.id}:invite")
    res
  end


  #给指定账户增加号码
  def add_codes_to_user(current_user, count=10)
    add_user_codes(current_user, pop_code(count))
  end

  #redis 中号码池
  def redis_keys
    "mammon_period:redis_keys:#{self.id}:codes"
  end

  #redis 中现金池
  def redis_cash_keys
    "mammon_period:redis_keys:#{self.id}:cash"
  end

  after_create :init_cash_keys
  #初始化现金池
  def init_cash_keys
    $redis.set(redis_cash_keys, self.invite_share_max_amount.to_i)
  end

  #redis 中号码池剩余个数
  def llen_pop_code
    # $redis.llen(redis_keys)
    $redis.smembers(redis_keys).size
  end

  #赠送号码
  def pop_code count = 1
    # res = []
    # count.times { res << $redis.lpop(redis_keys) }
    # res
    $redis.spop(redis_keys, count)
  end

  #赠送宝箱池中号码
  def pop_box_code count = 1
    # res = []
    # count.times { res << $redis.lpop(redis_keys) }
    # res
    $redis.spop(box_redis_keys, count)
  end

  #初始化抽奖号码池
  def init_pop_codes
    codes  = (0...10000).map { |x| "%04d" % x }.shuffle
    $redis.sadd(redis_keys, codes.first(9000))

    $redis.sadd(box_redis_keys, codes.last(1000))
    # $redis.lpush(redis_keys, (0...10000).map { |x| "%04d" % x }.shuffle)
  end

  def box_redis_keys
    "mammon_period:box_redis_keys:#{self.id}:codes"
  end

  #当前期次用户缓存的key
  def user_codes_key(current_user)
    "mammon_period:user_codes_key:#{self.id}:user_id:#{current_user.id}"
  end

  #当前用户持有的号码
  def user_codes(current_user)
    return $redis.smembers(user_codes_key(current_user))
  end

  #增加用户期次号码 codes arr
  def add_user_codes(current_user, codes)
    $redis.sadd(user_codes_key(current_user), codes)
  end

  #减少用户期次号码
  def pop_user_codes(current_user, count)
    $redis.spop(user_codes_key(current_user), count)
  end

  #用户卡牌效果
  def user_status(current_user)
    res = {}
    Mammon::Card::NUM.each do |num|
      res[num] = $redis.get(user_status_key(current_user, num)).to_i
    end
    res
  end

  #用户状态key
  def user_status_key(current_user, num)
    "mammon_period:user_status_key:#{self.id}:user_id:#{current_user.id}:num:#{num}"
  end

  #上一期已开奖的财神活动
  def self.previous
    where(status: 2).order(pre_begin_time: :desc).first
  end

  #当期财神活动
  def self.current
    # period = where(num: Date.today).order(:created_at).first
    where(status: 0).active.order(:pre_begin_time).first
  end

  #当前赠送的期次
  def self.current_give
    where("pre_begin_time < ?", Time.now).order(pre_begin_time: :desc).first
  end

  # 是否第一次登录
  def first_login? current_user
    flag = Rails.cache.read("logined_period_id:#{self.id}:user_id:#{current_user.id}") ? false : true
    self.set_login_record current_user
    return flag
  end

  # 创建登录记录
  def set_login_record current_user
    logined = Rails.cache.fetch("logined_period_id:#{self.id}:user_id:#{current_user.id}", expires_in: 3600*24*2) {
      true
    }
  end

  after_create :init_pop_codes

  def save_items! item_params
    self.period_items.update_all(delete_flag: true) unless self.new_record?
    4.times do |i|
      self.period_items.create!(
          prize_num: i,
          amount: item_params[i.to_s]['amount'],
          prize_count: item_params[i.to_s]['prize_count'],
      )
    end
    total_amount = self.period_items.sum { |i| i.amount * i.prize_count }
    self.update_attributes!(total_amount: total_amount)
  end

  # 邀请好友获取到的奖励
  def invite_prizes
    cash = $redis.get(redis_cash_keys).to_i
    codes = llen_pop_code.to_i
    res = {}
    code_count = (Setting.value("invite_code_count") || 5).to_i
    if codes > 0
      res = {code: code_count}
    else
      res = {card: 2}
    end
    # if cash > 0 && codes > 0
    #   res = {cash: self.invite_reward.to_f, code: code_count}
    # elsif codes > 0 && cash <= 0
    #   res = {code: code_count, card: 2}
    # elsif cash > 0 && codes <= 0
    #   res = {cash: self.invite_reward.to_f, card: 2}
    # elsif cash <= 0 && codes <= 0
    #   res = {card: 2}
    # end
    return res.as_json
  end

  #开奖
  def self.open_period
    current_period = Mammon::Period.current #当前需要开奖的期次
    return "此期还未到结算时间,期号ID=#{current_period.id}" if current_period.end_time > Time.now #此期还未到结算时间
    a0, a1, a2, a3 = 0, 0, 0, 0 #中奖总金额
    win_code = get_winning_number
    current_period.update_attributes(code: win_code, status: 2)
    awards = current_period.period_items.pluck(:prize_num, :id, :amount)
    keys = $redis.keys("mammon_period:user_codes_key:#{current_period.id}:user_id:*")
    keys.each do |key|
      user_codes = $redis.smembers(key)
      user_id = key.split(':').last
      user = User.includes(:account_ticket).where(id: user_id).first
      next if user.nil?
      #判断是否中奖
      user_codes.each do |c|
        if c == win_code
          #特等奖
          a0 += award_save! current_period, user, awards.assoc(0), c
          current_period.update_attributes(is_win: true) #幸运大奖是否开启
        elsif c[0..2] == win_code[0..2]
          #一等奖
          a1 += award_save! current_period, user, awards.assoc(1), c
        elsif c[0..1] == win_code[0..1]
          #二等奖
          a2 += award_save! current_period, user, awards.assoc(2), c
        elsif c[0] == win_code[0]
          #三等奖
          a3 += award_save! current_period, user, awards.assoc(3), c
        end
      end

    end
    #剩余奖品金额
    current_period.update_attributes(left_amount: current_period.total_amount.to_i - a0 - a1 - a2 -a3)
    #今日结算
    yesterday_balance_hash = Hash.new 0
    current_period.period_items.each do |item|
      case item.prize_num
        when 0
          yesterday_balance_hash[0] = item.amount * item.prize_count - a0
          item.update_attributes(today_balance: a0)
        when 1
          yesterday_balance_hash[1] = item.amount * item.prize_count - a1
          item.update_attributes(today_balance: a1)
        when 2
          yesterday_balance_hash[2] = item.amount * item.prize_count - a2
          item.update_attributes(today_balance: a2)
        when 3
          yesterday_balance_hash[3] = item.amount * item.prize_count - a3
          item.update_attributes(today_balance: a3)
      end
    end
    #昨日结转
    # next_period = Mammon::Period.includes(:period_items).where("num > ?", current_period.num).order(num: :asc).first
    # if next_period.present?
    #   next_period.period_items.each do |item|
    #     case item.prize_num
    #       when 0
    #         yesterday_balance_save!(item, yesterday_balance_hash[item.prize_num])
    #       when 1
    #         yesterday_balance_save!(item, yesterday_balance_hash[item.prize_num])
    #       when 2
    #         yesterday_balance_save!(item, yesterday_balance_hash[item.prize_num])
    #       when 3
    #         yesterday_balance_save!(item, yesterday_balance_hash[item.prize_num])
    #     end
    #   end
    #   next_period.update(total_amount: next_period.period_items.sum { |i| i.amount * i.prize_count })
    # end
  end


  #财神福利接口奖品信息
  def prize_items
    Rails.cache.fetch("period:#{self.id}:prize_items", expires_in: 10) {
      self.period_items.map { |pi| {'prize_num': pi.prize_num, 'amount': pi.amount}.as_json }
    }
  end

  # 已有用户数量
  def user_count

    last_count = Rails.cache.fetch("mammon_period:user_count:count", expires_in: 30 * 24 * 3600){
      2000
    }.to_i

    last_count_time = Rails.cache.fetch("mammon_period:user_count:time", expires_in: 30 * 24 * 3600){
      Time.now.to_i / 60
    }.to_i

    new_count = last_count + (rand(16) + 1) * ( (Time.now.to_i / 60  - last_count_time) ).to_i

    Rails.cache.write("mammon_period:user_count:count", new_count)
    Rails.cache.write("mammon_period:user_count:time", Time.now.to_i / 60 )

    return new_count
  end

  # 累计获得
  def total_gain
    last_count = Rails.cache.fetch("mammon_period:total_gain:count", expires_in: 30 * 24 * 3600){
      2800
    }.to_i

    last_count_time = Rails.cache.fetch("mammon_period:total_gain:time", expires_in: 30 * 24 * 3600){
      Time.now.to_i / 60
    }.to_i

    new_count = last_count + (rand(360) + 1) * ( (Time.now.to_i / 60  - last_count_time) ).to_i

    Rails.cache.write("mammon_period:total_gain:count", new_count)
    Rails.cache.write("mammon_period:total_gain:time", Time.now.to_i / 60)


    return new_count
  end

  def user_card_count user_id
    Rails.cache.fetch("current_period:#{self.id}:user:#{user_id}:card_count", expires_in: 15){
      self.user_cards.where(user_id: user_id)&.sum(:count)
    }
  end


  private

  class << self
    #中奖金额保存到账户
    def award_save! current_period, user, award, win_code
      begin
        prize_num = award[0] #奖品等级 0，1，2，3
        item_id = award[1] #期次奖励ID mammon_period_item_id
        amount = award[2].to_i #奖品金额
        account_ticket = AccountTicket.find(user.account_ticket.id)
        account_ticket.with_lock do
          user_winning = current_period.user_winnings.create!(mammon_period_item_id: item_id, user_id: user.id,
                                                              code: win_code, amount: amount, prize_num: prize_num)
          set_red_package(current_period.red_package_rule_id, user_winning, prize_num)
          user.account_ticket_balance_details.create!(fund: amount, trad_type: 6, level: prize_num)
          account_ticket.balance += amount
          account_ticket.save
        end
        return amount
      rescue Exception => e
        Rails.logger.info e.as_json
        return amount
      end
    end


    #开奖号码
    def get_winning_number
      number = ""
      begin
        res = JSON.parse(Faraday.new.get("https://box.maoyan.com/promovie/api/box/second.json").body)
        if res["success"] == true
          p "猫眼API:#{res['data']['totalBoxInfo']}"
          Rails.logger.info("猫眼API:#{res['data']['totalBoxInfo']}")
          last_number = res["data"]["totalBoxInfo"].delete(".").last
          if last_number
            3.times{number +=  Array(0..9).sample.to_s}
            number += last_number
          else
            number += Array(0..9).sample.to_s
          end
        else
          4.times{number +=  Array(0..9).sample.to_s}
        end
      rescue Exception => e
        p e
        4.times{number +=  Array(0..9).sample.to_s}
      end
      return number
    end

    #昨日结转
    # def yesterday_balance_save! period_item, amount
    def yesterday_balance_save! period_item, yesterday_balance
      # total_amount = period_item.prize_count.to_i * period_item.amount.to_i
      # yesterday_balance = total_amount - amount
      per_amount = 0
      if yesterday_balance > 0 && period_item.prize_count.to_i >= 1
        per_amount = yesterday_balance / period_item.prize_count.to_i
      end
      period_item.update_attributes(yesterday_balance: yesterday_balance, amount: period_item.amount + per_amount.to_i)
    end


    #红包规则，只有特等奖调用
    def set_red_package red_package_rule_id, user_winning, prize_num
      begin
        return false if prize_num != 0 #0表示特等奖
        rule = Promotion::RedPackageRule.find(red_package_rule_id)
        if rule.status == 0
          rule.new_red_package(user_winning, Time.now + rule.open_wait_time, Time.now + rule.open_wait_time + rule.close_wait_time)
        end
      rescue Exception => e
        Rails.logger.info "set_red_package:set_red_package:#{e.as_json}"
      end
    end
  end
end
