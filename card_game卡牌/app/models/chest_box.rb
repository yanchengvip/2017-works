class ChestBox < ApplicationRecord
  audited #日志记录
  self.table_name = 'chest_boxs'
  include AllocatingPrizesV2
  include RsaSign
  belongs_to :admin
  has_many :chest_box_prizes, -> { where(delete_flag: false).order(sort_num: :desc) }, dependent: :destroy
  has_many :chest_prizes, through: :chest_box_prizes
  serialize :output, Array
  has_many :chest_records
  has_many :chest_record_tmps
  serialize :prize_limit, Hash

  CHEST_TYPE = {1 => '青铜', 2 => '白银', 3 => '黄金', 4 => '铂金', 5 => 'APP注册', 6 => 'h5推广',  7 => '固定现金宝箱', 8 => "随机现金宝箱" }

  # {1 => '实物', 2 => '入场券', 3 => '兑奖券', 5 => '宝箱券', 6 => '现金券', 7 => '话费', 9 => '京东卡', 10 => '现金'}
  UNIQUE_PRIZE_TYPE = [1, 7, 9, 10]

  OPEN_TYPE = {1 => '免费次数', 2 => '宝箱符'}
  STATUS = {0 => '未开启', 1 => '已开启', 2 => '已停止', 3 => "后台开启中"}

  CURRENT_BOX_TYPES = [2,3,4]

  validates :period, uniqueness: true, if: Proc.new { |box| !box.delete_flag && self.period.present? }
  validates_length_of :period, maximum: 10, message: "期号不能超过10个字符"

  #关闭所有开大奖后的宝箱
  def self.close
    # where(status: 1, big_prize_win: true).each do |chest_box|
    #   time = chest_box.chest_records.where(big_prize_id: chest_box.big_prize_id).first&.created_at
    #   if time && (Time.now - time)/3600 > chest_box.hours_to_next
    #     chest_box.close
    #   end
    # end
    where("status = 1 and end_time < ? ", Time.now).each do |chest_box|
      chest_box.close
    end
  end

  #预上架， 成功返回true
  def test_lottery
    if self.chest_type == 6 #h5推广
      self.init_jd_card_box_redis
      self.update(status: 1)
      return true
    elsif self.chest_type == 5 #APP注册
      self.update(status: 1)
      return true
    elsif self.chest_type == 7 || self.chest_type == 8 #7 => '固定现金宝箱', 8 => "随机现金宝箱"
      self.init_cash_box
      self.update(status: 1)

    else
      if (self.status == 0 || self.status == 3) &&$redis.llen( redis_key) == 0
        unique_ids = self.chest_prizes.where(prize_type: ChestBox::UNIQUE_PRIZE_TYPE).pluck(:id)#单手互斥ID
        res = ChestBox.test_chest(self.hands, prize_data, self.output, self.prize_min, self.prize_max, given_prizes, special_prizes, unique_ids)
        if res[:tag] == true
          self.init_redis(res[:res])
          sleep 1
          self.update(status: 1)
          return true
        else
          return res[:tag]
        end
      else
        return "宝箱状态异常"
      end
    end
  end

  #特定奖品
  def special_prizes
    self.chest_box_prizes.where(prize_type: 3).map { |x| [x.chest_prize_id, x.base_num, x.min_index, x.max_index] }
  end

  #指定奖品
  def given_prizes
    self.chest_box_prizes.where(prize_type: 2).map { |x| [x.chest_prize_id, x.base_num] }
  end

  #随机奖品
  def prize_data
    self.chest_box_prizes.where(prize_type: 1).map { |x| [x.chest_prize_id, x.base_num, x.chest_prize.price, x.level] }
  end

  # 手数小于等于 10000
  validates :hands, numericality: {less_than_or_equal_to: 100000}

  # STATUS = {0 => '未开启', 1 => '已开启', 2 => '已停止'}

  #获取当前各个类型的首个宝箱
  def self.current_boxs
    Rails.cache.fetch("chest_boxs_current_boxs", expires_in: 10) {
      res = {}
      ChestBox::CURRENT_BOX_TYPES.each do |key|
        if chest_box = ChestBox.current(key)
          chest_prizes = chest_box.chest_prizes.where("chest_box_prizes.is_prior = true")
          win_user = {}
          if chest_box.big_prize_win && win_user_id = chest_box.chest_records.where(big_prize_id: chest_box.big_prize_id).first&.user_id
            win_user = User.where(id: win_user_id).first
          end
          res[key] = {chest_box: chest_box, chest_prizes: chest_prizes.as_json.map { |x| x.merge({level: chest_box.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level, left_count: chest_box.left_prize_count(x["id"]) }) }, big_chest_prize: chest_box.chest_prizes.where(id: chest_box.big_prize_id).first.as_json.merge(left_count: chest_box.left_prize_count(chest_box.big_prize_id)), win_user: win_user, left_count: $redis.llen( chest_box.redis_key)}
        end
      end
      res.as_json
    }
  end

  #当前抽奖的宝箱
  def self.current(chest_type = 1)
    ChestBox.where("chest_type = ? and status = 1 and begin_time < ? and end_time > ?", chest_type, Time.now, Time.now).order(id: :asc).first
  end

  #下一个宝箱
  def self.next(chest_type = 1)
    boxs = ChestBox.where("chest_type = ? and status = 1  and end_time > ?", chest_type, Time.now).order(id: :asc).limit(2)
    return boxs[1]
  end

  #关闭宝箱
  def close
    self.update(status: 2)
    self.clear_redis_key
    return true
  end

  def get_last_draw_time ip
    Rails.cache.fetch("last_draw_time:#{ip}", expires_in: 100){
      Time.now.to_f
    }.to_f
  end

  #初始化宝箱奖品数据
  def init_jd_card_box_redis
    data = []
    self.chest_box_prizes.where(prize_type: 7).each do |cbp| #随机JD卡奖品
      data += Array.new(cbp.base_num, cbp.chest_prize_id)
    end
    $redis.lpush(jd_card_redis_key(1), data.shuffle)

    data = []
    self.chest_box_prizes.where(prize_type: 8).each do |cbp| #固定JD卡奖品
      data += Array.new(cbp.base_num, cbp.chest_prize_id)
    end
    $redis.lpush(jd_card_redis_key(0), data.shuffle)
  end

  #0 #固定宝箱奖品  1随机京东卡宝箱
  def jd_card_redis_key(type)
    "chest_box:#{self.id}:prizes:type:#{type}"
  end

  def user_day_total_draw_cash_key(current_user)
    key = "draw_chest_box:cash:#{Date.today.to_s}:#{current_user.id}"
    $redis.sadd(redis_history_keys, key)
    return key
  end
  def draw_cash(current_user)
    # if self.chest_type ==
    if $redis.incrby(user_day_total_draw_cash_key(current_user), 1) > (Setting.value("draw_cash_max_count_every_day") || 20).to_i
      res = {"execResult" => false, "execMsg" => "每天只能开启20个红包，请明日再来", "execData" => {}, "execDatas" => [], "execErrCode" => "5003"}
      return res
    end

    account_ticket = current_user.account_ticket
    res = {}
    account_ticket.with_lock do
      if account_ticket.free_treasure_amount > 0
        if chest_prize_ids = $redis.lpop(redis_key)
          account_ticket.update!(free_treasure_amount: account_ticket.free_treasure_amount - 1)
          chest_record = self.chest_records.create!(user_id: current_user.id, chest_prize_ids: chest_prize_ids, deduction_prize_ids: "", chest_box_open_type: self.open_type, chest_type: self.chest_type)
          res = {"execResult" => true, "execMsg" => "", "execData" => {chest_record: chest_record, chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: self.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }}, "execDatas" => [], "execErrCode" => "200"}
        else
          $redis.decrby(user_day_total_draw_cash_key(current_user), 1)
          self.close
          res = {"execResult" => false, "execMsg" => "红包已抢空", "execData" => {}, "execDatas" => [], "execErrCode" => "5002"}
        end
      else
        $redis.decrby(user_day_total_draw_cash_key(current_user), 1)
        res = {"execResult" => false, "execMsg" => "邀请次数不足", "execData" => {}, "execDatas" => [], "execErrCode" => "5001"}
      end
    end
    return res
  end

  # 7 => '固定现金宝箱', 8 => "随机现金宝箱"
  # 9: 固定现金宝箱 10: 随机现金宝箱
  def init_cash_box
    res = []
    if self.chest_type == 7
      self.chest_box_prizes.where(prize_type: 9).each do |x|
        x.base_num.times do
          res << x.chest_prize_id
        end
      end
    elsif self.chest_type == 8
      self.chest_box_prizes.where(prize_type: 10).each do |x|
        x.base_num.times do
          res << x.chest_prize_id
        end
      end
    end
    $redis.lpush(redis_key, res.shuffle)
  end


  #h5推广固定奖品 和随机奖品（JD卡）抽奖规则
  def draw_jd_card(type)
    send_sm_to_operate() if([1000, 500, 200, 50].include?($redis.llen(jd_card_redis_key(type)) ))
    if(chest_prize_ids = $redis.lpop(jd_card_redis_key(type)))
      chest_record_tmp = self.chest_record_tmps.create(chest_prize_ids: chest_prize_ids, chest_box_chest_type: self.chest_type, status: 0)
      return {"execResult" => true, "execMsg" => "抽奖成功", "execData" => {chest_record_tmp: chest_record_tmp,
        chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: self.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }}, "execDatas" => [], "execErrCode" => "200"}.with_indifferent_access
    else
      if $redis.llen(jd_card_redis_key(0)).to_i == 0 && $redis.llen(jd_card_redis_key(1)).to_i == 0
        self.close()
      end
      return {"execResult" => false, "execMsg" => "已领空", "execData" => {}, "execDatas" => [], "execErrCode" => "500"}
    end
  end

  def send_sm_to_operate
    begin
      ["18522118286", "13718533929", "15810957763"].each do |phone|
      CardSms.send_message(phone,"推广宝箱剩余京东卡数量： 固定#{$redis.llen(jd_card_redis_key(0))}， 随机：#{$redis.llen(jd_card_redis_key(1))} ")
    end
    rescue Exception => e

    end

  end

  #app开屏宝箱抽奖 先抽实物， 实物有 再抽 虚拟 实物没有则虚拟必中
  def draw_app_landing_box
    #实物奖品 5: app注册实物，6:app注册虚拟，7:h5随机，8:h5固定
    chest_box_prize = self.chest_box_prizes.where(prize_type: 5).where("left_num > 0").sample

    entity_prize = ""
    if chest_box_prize
      chest_box_prize.with_lock do
        if chest_box_prize.left_num > 0 && chest_box_prize.odds_cal
          chest_box_prize.update!(left_num: chest_box_prize.left_num - 1)
          entity_prize = chest_box_prize.chest_prize_id
        end
      end
    end

    chest_prize_ids = entity_prize.to_s
    #虚拟奖品
    chest_box_prize = self.chest_box_prizes.where(prize_type: 6).sample
    if chest_box_prize
      if entity_prize.blank?
        chest_prize_ids = chest_box_prize.chest_prize_id.to_s
      else
        if chest_box_prize.odds_cal
          chest_prize_ids ="#{chest_prize_ids},#{chest_box_prize.chest_prize_id}"
        end
      end
    end
    chest_record_tmp = self.chest_record_tmps.create(chest_prize_ids: chest_prize_ids, chest_box_chest_type: self.chest_type, status: 0)
    return {"execResult" => true, "execMsg" => "抽奖成功", "execData" => {
      sign: ChestBox.rsa_private_sign(chest_record_tmp.id.to_s, SYSTEMCONFIG[:rsa][:private_key]),
      chest_record_tmp: chest_record_tmp,
        chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: self.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }}, "execDatas" => [], "execErrCode" => "200"}.with_indifferent_access
  end


  #抽奖
  def draw current_user, request
    unless ChestBox::CURRENT_BOX_TYPES.include? self.chest_type
      return {"execResult" => false, "execMsg" => "宝箱已经抢完", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
    end
    if $redis.llen(redis_key) <= self.notice_num && self.is_jpush_notcie == false
      begin
        self.update(is_jpush_notcie: true)
        ChestBox.send_msg(self.notice_copy, self.notice_copy)
      rescue Exception => e
      end
    end

    draw_message = self.draw_message current_user #判断下一次抽奖显示内容

    if self.status != 1
      return {"execResult" => false, "execMsg" => "宝箱已经抢完", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
    end

    #连续抽奖时间间隔设置
    if(Time.now.to_f - get_last_draw_time(request.remote_ip) < (Setting.value("draw_time_interval") || 1).to_f )
      return {"execResult" => false, "execMsg" => "抽奖速度太快了", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
    end
    Rails.cache.write("last_draw_time:#{request.remote_ip}", Time.now.to_f)


    #每个宝箱 单用户最大抽取次数
    if $redis.incrby(user_total_draw_key(current_user), 1).to_i > self.times_max
      $redis.decrby(user_total_draw_key(current_user), 1)
      return {"execResult" => false, "execMsg" => "本期#{ChestBox::CHEST_TYPE[self.chest_type]}宝箱开启次数已达上限", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
    end

    res = {}
    account_ticket = current_user.account_ticket
    if self.open_type == 1
      res = free_treasure_draw(current_user, draw_message)
    elsif self.open_type == 2
      res = treasure_draw(current_user, draw_message)
    end
  end

  #免费抽奖次数抽奖
  def free_treasure_draw current_user, draw_message
    account_ticket = current_user.account_ticket
    account_ticket.with_lock do
      if account_ticket.free_treasure_amount >= self.treasure_amount
        if chest_prize_ids = $redis.lpop(redis_key)
          account_ticket.update!(free_treasure_amount: account_ticket.free_treasure_amount - self.treasure_amount)

          account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["免费宝箱宝符"], fund: self.treasure_amount, wealth_type: 1, trad_type: AccountTicketDetail::TRADTYPE["开宝箱"], create_time: Time.now)

          chest_prize_ids, deduction = exchange_prizes(chest_prize_ids, current_user)

          deduction_to_redis(deduction)

          if chest_prize_ids.split(",").include? self.big_prize_id.to_s
            self.update(big_prize_win: true)
            chest_record = self.chest_records.create!(user_id: current_user.id, chest_prize_ids: chest_prize_ids, big_prize_id: self.big_prize_id, deduction_prize_ids: deduction.join(","), chest_box_open_type: self.open_type, chest_type: self.chest_type)
          else
            chest_record = self.chest_records.create!(user_id: current_user.id, chest_prize_ids: chest_prize_ids, deduction_prize_ids: deduction.join(","), chest_box_open_type: self.open_type, chest_type: self.chest_type)
          end
          if $redis.llen(redis_key) == 0
            self.close
          end
          #减掉缓存中的奖品数量
          chest_prize_ids.split(",").each do |p_id|
            $redis.decrby(left_prize_keys(p_id), 1)
          end
          draw_message = self.draw_message current_user
          res = {"execResult" => true, "execMsg" => "抽奖成功", "execData" => {chest_record: chest_record, chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: self.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }, draw_message: draw_message}, "execDatas" => [], "execErrCode" => "200"}
        else
          self.close
          # $redis.decrby(user_day_total_draw_key(current_user), self.treasure_amount)
          $redis.decrby(user_total_draw_key(current_user), 1)
          $redis.decrby("draw_chest_box:#{Date.today.to_s}:#{current_user.id}", self.treasure_amount)
          res = {"execResult" => false, "execMsg" => "没抢到宝箱，再试一下", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
        end
      else
        # $redis.decrby(user_day_total_draw_key(current_user), self.treasure_amount)
        $redis.decrby(user_total_draw_key(current_user), 1)
        $redis.decrby("draw_chest_box:#{Date.today.to_s}:#{current_user.id}", self.treasure_amount)
        res = {"execResult" => false, "execMsg" => "开奖次数不足", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "5001"}
      end
    end
  end

  #使用宝相符抽奖
  def treasure_draw current_user, draw_message
    account_ticket = current_user.account_ticket
    account_ticket.with_lock do
      if account_ticket.treasure_total_amount >= self.treasure_amount
        if chest_prize_ids = $redis.lpop(redis_key)
          account_ticket.update!(treasure_total_amount: account_ticket.treasure_total_amount - self.treasure_amount)

          account_ticket.account_ticket_details.create!(user_id: current_user.id, type: AccountTicketDetail::DETAILTYPE["宝箱宝符"], fund: self.treasure_amount, wealth_type: 1, trad_type: AccountTicketDetail::TRADTYPE["开宝箱"], create_time: Time.now)

          chest_prize_ids, deduction = exchange_prizes(chest_prize_ids, current_user)

          deduction_to_redis(deduction)

          if chest_prize_ids.split(",").include? self.big_prize_id.to_s
            self.update(big_prize_win: true)
            chest_record = self.chest_records.create!(user_id: current_user.id, chest_prize_ids: chest_prize_ids, big_prize_id: self.big_prize_id, deduction_prize_ids: deduction.join(","), chest_box_open_type: self.open_type, chest_type: self.chest_type)
          else
            chest_record = self.chest_records.create!(user_id: current_user.id, chest_prize_ids: chest_prize_ids, deduction_prize_ids: deduction.join(","), chest_box_open_type: self.open_type, chest_type: self.chest_type)
          end
          if $redis.llen(redis_key) == 0
            self.close
          end
          #减掉缓存中的奖品数量
          chest_prize_ids.split(",").each do |p_id|
            $redis.decrby(left_prize_keys(p_id), 1)
          end
          draw_message = self.draw_message current_user
          res = {"execResult" => true, "execMsg" => "抽奖成功", "execData" => {chest_record: chest_record, chest_prizes: ChestPrize.get_prizes_by_ids(chest_prize_ids).map { |x| x.merge({level: self.chest_box_prizes.select { |cbs| cbs.chest_prize_id == x["id"] }&.first&.level}) }, draw_message: draw_message}, "execDatas" => [], "execErrCode" => "200"}
        else
          self.close
          # $redis.decrby(user_day_total_draw_key(current_user), self.treasure_amount)
          $redis.decrby(user_total_draw_key(current_user), 1)
          $redis.decrby("draw_chest_box:#{Date.today.to_s}:#{current_user.id}", self.treasure_amount)
          res = {"execResult" => false, "execMsg" => "没抢到宝箱，再试一下", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "500"}
        end
      else
        # $redis.decrby(user_day_total_draw_key(current_user), self.treasure_amount)
        $redis.decrby(user_total_draw_key(current_user), 1)
        $redis.decrby("draw_chest_box:#{Date.today.to_s}:#{current_user.id}", self.treasure_amount)
        res = {"execResult" => false, "execMsg" => "宝箱符不足", "execData" => {draw_message: draw_message}, "execDatas" => [], "execErrCode" => "5001"}
      end
    end
  end

  #三次必中奖品 安慰奖
  def consolation_prize current_user
    if $redis.get(user_total_draw_key(current_user)).to_i == 3
      if self.open_type == 1 && self.chest_records.where(chest_box_open_type: 1, prize_type: [1, 7], user_id: current_user.id).count == 0 #免费宝箱
        self.chest_box_prizes.where(prize_type: 4).pluck(:chest_prize_id)
      elsif self.open_type == 2 && self.chest_records.where(prize_type: [1, 7], user_id: current_user.id).count == 0 #宝符宝箱 3次都未种实物奖品
        self.chest_box_prizes.where(prize_type: 4).pluck(:chest_prize_id)
      else
        []
      end
    else
      []
    end
  end


  #抽奖领取后，返回抽奖页面的提示信息
  def draw_message current_user
    res = {is_draw: true, msg: '可以继续抽此宝箱'} #is_draw 表示是否可以继续抽此宝箱
    account_ticket = current_user.account_ticket
    treasure_total_amount = account_ticket.treasure_total_amount #付费宝箱符
    free_treasure_amount = account_ticket.free_treasure_amount #免费宝箱符

    #付费宝箱
    chest_box = ChestBox.where("status = 1 and begin_time < ? and end_time > ? and treasure_amount <= ? and open_type = ?", Time.now, Time.now, treasure_total_amount, 2).active.order(treasure_amount: :desc).first

    chest_box_msgs = ChestBoxMsg.where(msg_type: [1, 2, 3, 4, 5]).order(msg_type: :asc).active
    #情况1 开启免费宝箱，次数不足，但拥有宝箱券可开启任意一个宝箱
    if self.open_type == 1 && free_treasure_amount <= 0 && chest_box.present?
      msg = chest_box_msgs.select { |x| x.msg_type == 1 }.first
      msg_info = get_msg_content msg,chest_box,free_treasure_amount,treasure_total_amount
      res = {is_draw: false, msg: msg_info, chest_box_id: chest_box.id, remark: '情况1', msg_type: 1}
    end

    #情况2 开启当前付费宝箱（宝箱符开启），宝箱符数量不足，但拥有宝箱券可开启其他付费宝箱
    if self.open_type == 2 && treasure_total_amount < self.treasure_amount && chest_box.present?
      msg = chest_box_msgs.select { |x| x.msg_type == 2 }.first
      msg_info = get_msg_content msg,chest_box,free_treasure_amount,treasure_total_amount
      res = {is_draw: false, msg: msg_info, chest_box_id: chest_box.id, remark: '情况2', msg_type: 2}
    end

    #情况3，开启付费宝箱后，剩余宝箱符无法开启任何付费宝箱，且拥有免费开启次数
    if self.open_type == 2 && free_treasure_amount > 0 && chest_box.nil?
      msg = chest_box_msgs.select { |x| x.msg_type == 3 }.first
      free_chest_box = ChestBox.where("status = 1 and begin_time < ? and end_time > ? and open_type = ?", Time.now, Time.now, 1).active.first
      msg_info = get_msg_content msg,chest_box,free_treasure_amount,treasure_total_amount
      res = {is_draw: false, msg: msg_info, chest_box_id: free_chest_box&.id, remark: '情况3', msg_type: 3}
    end

    #情况4，用户开启完宝箱后，所有免费次数、宝箱符数量均不足开启任何一个宝箱
    if free_treasure_amount <= 0 && chest_box.nil?
      msg = chest_box_msgs.select { |x| x.msg_type == 4 }.first
      res = {is_draw: false, msg: msg&.content, remark: '情况4', msg_type: 4}
    end

    return res

  end

  def get_need_battle_count current_user
    if current_user.is_new_user?
      (Setting.value("new_user_play_count").to_i - current_user.get_battle_count).to_i
    else
      (Setting.value("old_user_play_count").to_i - current_user.get_battle_count).to_i
    end
  end
  #用户抽奖总次数
  def user_total_draw_key(current_user)
    key = "draw_chest_box:#{self.id}:#{current_user.id}"
    $redis.sadd(redis_history_keys, key)
    return key
  end

  #用户当天抽奖次数
  def user_day_total_draw_key(current_user)
    key = "draw_chest_box:#{self.id}:#{Date.today.to_s}:#{current_user.id}"
    $redis.sadd(redis_history_keys, key)
    return key
  end


  #将用户扣除奖品结果添加到redis
  def deduction_to_redis(deduction)
    unless deduction.blank?
      ids = self.chest_box_prizes.where(prize_type: 2).pluck(:chest_prize_id)
      ids.each do |p_id|
        $redis.incrby(left_prize_keys(p_id), 1)
      end
      res = deduction + ids
      $redis.lpush(redis_key, res.join(','))
    end
  end


  #根据抽奖结果，和当前用户 返回 可领取奖励结果， 和扣除奖品结果
  def exchange_prizes(prize_ids, current_user)
    res = []
    deduction = []
    contain_entity_prize = false #包含实物奖品
    ChestPrize.get_prizes_by_ids(prize_ids).each do |prize|
      # prize = ChestPrize.find(p_id)
      p_id = prize["id"]
      if prize["prize_type"].to_i == 11 && period = Mammon::Period.current  #财神号码
        period_codes = period.pop_box_code(1)
        unless period_codes.blank?
          period.add_user_codes(current_user, period_codes)
          res << p_id
          Mammon::UserCode.create(user_id: current_user.id, period_id: period.id, codes: period_codes.join(","), count: period_codes.size, source_type: 5)
        end
        next
      end
      redis_add_count = ((prize["prize_type"] == 7) ? 1 : prize["num"]).to_i
      count = $redis.incrby(prize_redis_key(prize["prize_type"], current_user), redis_add_count) #免费宝箱 话费卡限制个数
      if self.open_type == 2 #收费宝箱
        if count <= self.prize_limit[prize["prize_type"]].to_f || self.prize_limit[prize["prize_type"]].to_f == 0
          contain_entity_prize = true if prize["prize_type"] == 1 || prize["prize_type"] == 7
          res << p_id
        else
          $redis.decrby(prize_redis_key(prize["prize_type"], current_user), redis_add_count)
          deduction << p_id
        end
      else #免费宝箱
        if count <= self.prize_limit[prize["prize_type"]].to_f || self.prize_limit[prize["prize_type"]].to_f == 0
          if (prize["prize_type"] == 1 || prize["prize_type"] == 7) && current_user.chest_records.where(chest_box_open_type: 1).count < 3 #前两次不中实物奖品 及话费
            deduction << p_id
          else
            contain_entity_prize = true if prize["prize_type"] == 1 || prize["prize_type"] == 7
            res << p_id
          end
        else
          $redis.decrby(prize_redis_key(prize["prize_type"], current_user), redis_add_count)
          deduction << p_id
        end
      end
    end

    if contain_entity_prize #饱含实物
      return res.join(","), deduction
    else
      return (res + consolation_prize(current_user)).last(self.prize_max).join(","), deduction
    end
  end

  #每用户领取的每个品类奖品数量 redis key
  def prize_redis_key(p_type, current_user)
    key = "chest_box:#{self.id}:prizes:#{current_user.id}:#{p_type}"
    $redis.sadd(redis_history_keys, key)
    return key
  end

  #宝箱开启初始化redis信息
  def init_redis(data)
    $redis.rpush(redis_key, data.map { |x| x.join(",") })
    h = Hash.new 0
    data.flatten.each do |x|
      h[x] += 1
    end
    h.each do |k, v|
      $redis.set(left_prize_keys(k), v)
      $redis.sadd(redis_history_keys, left_prize_keys(k))
    end

  end

  #所有奖品剩余数量
  def left_prizes_count
    res = {}
    self.chest_prizes.each do |x|
      res[x.id] = left_prize_count(x.id)
    end
    return res
  end

  #单个奖品 剩余数量
  def left_prize_count prize_id
    $redis.get(left_prize_keys prize_id).to_i
  end

  #奖品剩余数量 redis key
  def left_prize_keys prize_id
    "chest_box:#{self.id}:prize_id#{prize_id}"
  end

  #清空宝箱 所有redis key
  def clear_redis_key
    $redis.del(redis_key)
    $redis.smembers(redis_history_keys).each_slice(100).to_a.each do |keys|
      $redis.del(keys)
    end
  end

  #该宝箱所有redis key
  def redis_history_keys
    "chest_box:#{self.id}:history_keys"
  end

  #宝箱奖品redis 队列
  def redis_key
    "chest_box:#{self.id}:prizes"
  end


  def save_prizes! prize_params, appoint_params, given_params, three_params, app_product_params, app_virtual_params, h5_random_params, h5_fix_params, cash_fix_params, cash_random_params
    flag = 0
    [prize_params, appoint_params, given_params, three_params, app_product_params, app_virtual_params].each do |params|
      params && params.each do |param|
        flag += 1 if param['level'].to_i == 1
      end
    end
    unless flag == 1 || self.chest_type.in?([6,7,8])
      raise '每个宝箱必须有且只能有一个幸运大奖！'
    end

    red = {flag: 0, rule_product_ids: [], is_repeat: false}
    given_size = given_params&.size
    given_params && given_params.each do |param|
      if !param['red_package_rule_id'].blank?
        red[:flag] += 1
        red[:rule_product_ids] << param['chest_prize_id']
        red[:is_repeat] = true if red[:rule_product_ids]&.include?(param['chest_prize_id']) && red[:flag] > 1
      end
    end
    raise '红包对应的商品不能重复' if red[:is_repeat] == true
    if red[:flag] >= 1
      [prize_params, appoint_params, three_params, app_product_params, app_virtual_params, cash_fix_params, cash_random_params].each do |params|
        params && params.each do |param|
          red[:is_repeat] = true if red[:rule_product_ids]&.include?(param['chest_prize_id'])
        end
      end
    end
    raise '红包对应的商品不能重复' if red[:is_repeat] == true

    unless self.new_record?
      self.chest_box_prizes.update_all(delete_flag: true)
    end
    [prize_params, appoint_params, given_params, three_params, app_product_params, app_virtual_params, h5_random_params, h5_fix_params, cash_fix_params, cash_random_params].each do |params|
      params && params.each do |param|
        box_prize = self.chest_box_prizes.create!(param.permit!.slice('level', 'chest_prize_id', 'base_num', 'worth', 'prize_type', 'min_index', 'max_index', 'is_prior', 'sort_num', 'odds', 'red_package_rule_id').merge(left_num: param['base_num']))
        if box_prize.level == 1
          self.update_attribute(:big_prize_id, box_prize.chest_prize.id)
        end
      end
    end
    self.check_type!
  end

  def self.send_msg title, content
    # res = MsgRecord.push_msg(SYSTEMCONFIG['java_redis_url'], "/card-service-web/msg/sendPushMsg", {title: title, content: content})
  end

  def copy! admin_id
    res = {status: false, msg: '复制失败'}
    cbps = self.chest_box_prizes
    begin
      ActiveRecord::Base.transaction do
        box = ChestBox.create!(self.attributes.except("id", "status", "parent_id", "admin_id", "created_at", "updated_at", "big_prize_id", "big_prize_win", 'period').merge(admin_id: admin_id).merge(parent_id: self.id).merge(period: ''))
        if box
          cbps.each do |cbp|
            box.chest_box_prizes.create!(cbp.attributes.except("id", "chest_box_id", "created_at", "updated_at"))
          end
          res = {status: true, msg: '复制成功'}
        end
      end
    rescue Exception => e
      res = {status: false, msg: '复制失败' + e.to_s}
    end

    res
  end

  def add_prize! app_product_params, app_virtual_params
    big = self.chest_box_prizes.where(level: 1)
    flag = big.blank? ? 0 : 1
    [app_product_params, app_virtual_params].each do |params|
      params && params.each do |param|
        flag += 1 if param['level'].to_i == 1
      end
    end
    unless flag == 1
      raise '每个宝箱必须有且只能有一个幸运大奖！'
    end

    [app_product_params, app_virtual_params].each do |params|
      params && params.each do |param|
        box_prize = self.chest_box_prizes.create!(param.permit!.slice('level', 'chest_prize_id', 'base_num', 'worth', 'prize_type', 'is_prior', 'sort_num', 'odds').merge(left_num: param['base_num']))
        if box_prize.level == 1
          self.update_attribute(:big_prize_id, box_prize.chest_prize.id)
        end
      end
    end
  end

  def total_prize_num
    total_num = 0
    self.chest_box_prizes.each do |box_prize|
      if box_prize.prize_type == 2
        total_num += self.hands * box_prize.base_num
      else
        total_num += box_prize.base_num
      end
    end
    total_num
  end

  def check_type!
    self.chest_box_prizes.where(prize_type: self.exclude_types).update_all(delete_flag: true)
  end

  def exclude_types
    res = []
    case self.chest_type
    when 1,2,3,4
      res = [5,6,7,8,9,10]
    when 5
      res = [7,8,9,10]
    when 6
      res = [1,2,3,4,5,6,9,10]
    when 7
      res = [1,2,3,4,5,6,7,8,10]
    when 8
      res = [1,2,3,4,5,6,7,8,9]
    end
    res
  end


  private

  def get_msg_content chest_box_msg,chest_box,free_treasure_amount,treasure_total_amount
    box_name = ''
    msg_info = '再接再厉哦'
    if chest_box_msg && chest_box_msg&.content.present?
      box_name = chest_box&.name.to_s if chest_box&.name.present?
      msg_info = chest_box_msg.content.to_s.gsub("{free_treasure_amount}", free_treasure_amount.to_s).gsub("{box_name}", box_name).gsub("{treasure_amount}",treasure_total_amount.to_s)
    end
    return msg_info
  end

end
