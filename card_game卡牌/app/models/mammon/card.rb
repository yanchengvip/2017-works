class Mammon::Card < ApplicationRecord
  CARDTYPE = {1 => '单枪', 2 => '嫁祸', 3 => '消耗', 4 => "反抢", 5 => "增幅", 6 => "互换", 7 => "群抢"}
  NUM = ["danqiang", "jiahuo", "xiaohao", "fanqiang", "zengfu", "huhuan", "qunqiang"]
  #is_program 0 用户 1 程序
  def self.use current_user, card_id, to_user_id = nil, is_program = false
    res = {}
    if period = Mammon::Period.current
      if period.end_time - Time.now  < period.rest_time
        return {
                "execResult": false,
                "execMsg": "结算时间不可使用卡牌",
                "execData": {},
                "execDatas": [],
                "execErrCode": "500"
              }
      end
      user_card = Mammon::UserCard.where(user_id: current_user.id, card_id: card_id, period_id: period.id).lock(true).last
      if user_card && user_card.count > 0
        user_card.with_lock do


          case num = user_card.card.num
          when "danqiang"
            res = danqiang_action(to_user_id, current_user, period, user_card, is_program)
            if res[:execErrCode] == "200" || res[:execErrCode] == "600"
              user_card.update!(count: user_card.count - 1)
            end
          when "jiahuo", "xiaohao", "fanqiang", "zengfu"
            if $redis.incrby(period.user_status_key(current_user, num), 1).to_i == 1
              user_card.update!(count: user_card.count - 1)
              Mammon::AttackRecord.create(from_user_id: current_user.id,  period_id: period.id, card_id: card_id, is_program: is_program)
              res = {
                "execResult": true,
                "execMsg": "",
                "execData": {num: num},
                "execDatas": [],
                "execErrCode": "200"
              }
            else
              $redis.decrby(period.user_status_key(current_user, num), 1)
              res = {
                "execResult": false,
                "execMsg": "卡牌不能重复使用",
                "execData": {},
                "execDatas": [],
                "execErrCode": "500"
              }
            end
          when "huhuan"
            if to_user_id
              key = "mammon_period:user_codes_key:#{period.id}:user_id:#{to_user_id}"
            else
              key = self.get_to_user_key period, current_user
            end
            unless key
              return {
                "execResult": false,
                "execMsg": "当前没有可掠夺对象",
                "execData": {},
                "execDatas": [],
                "execErrCode": "500"
              }
            end

            if period.user_codes(current_user).size > 0
              user_card.update!(count: user_card.count - 1)
              to_user = User.where(id: key.split("user_id:").last).first
              to_user_codes = period.pop_user_codes(to_user, 10000)
              user_codes = period.pop_user_codes(current_user, 10000)

              period.add_user_codes(current_user, to_user_codes)
              period.add_user_codes(to_user, user_codes)

              attack_record = Mammon::AttackRecord.create!(from_user_id: current_user.id, to_user_id: key.split("user_id:").last, period_id: period.id, codes: to_user_codes.join(","), card_id: user_card.card_id)
              Mammon::UserCode.create!(user_id: current_user.id, period_id: period.id, codes: to_user_codes.join(","), count: to_user_codes.count,  source_type: 2)
              Mammon::UserCode.create!(user_id: current_user.id, period_id: period.id, codes: user_codes.join(","), count: user_codes.count,  source_type: 1, attack_user_id: to_user.id)
              Mammon::UserCode.create!(user_id: to_user.id, period_id: period.id, codes: to_user_codes.join(","), count: to_user_codes.count,  source_type: 1, attack_user_id: current_user.id)
              Mammon::UserCode.create!(user_id: to_user.id, period_id: period.id, codes: user_codes.join(","), count: user_codes.count,  source_type: 2)

              res = {
                "execResult": true,
                "execMsg": "",
                "execData": {num: num, codes: to_user_codes, count: to_user_codes.size, to_user: to_user, current_user: current_user},
                "execDatas": [],
                "execErrCode": "200"
              }
            else
              res = {
                "execResult": false,
                "execMsg": "使用互换技能自身抽奖号码数需大于0",
                "execData": {},
                "execDatas": [],
                "execErrCode": "500"
              }
            end
          when "qunqiang"
            keys = []
            10.times{keys << self.get_to_user_key(period, current_user)}
            keys = keys.compact.uniq.first(5)
            all_codes = []
            to_users = []
            if keys.blank?
              return {
                "execResult": false,
                "execMsg": "当前没有可掠夺对象",
                "execData": {},
                "execDatas": [],
                "execErrCode": "500"
              }
            end
            user_card.update!(count: user_card.count - 1)
            keys.each do |key|
              to_user = User.where(id: key.split("user_id:").last).first
              to_users <<  to_user
              codes = []
              count = ($redis.smembers(key).size * user_card.card.effect_percent).ceil
              if count > 0
                codes = period.pop_user_codes(to_user, count)
              end
              attack_record = Mammon::AttackRecord.create!(from_user_id: current_user.id, to_user_id: key.split("user_id:").last, period_id: period.id, codes: codes.join(","), card_id: user_card.card_id, is_program: is_program)
              # Mammon::UserCode.create!(user_id: current_user.id, period_id: period.id, codes: codes.join(","), count: codes.count,  source_type: 2)
              Mammon::UserCode.create!(user_id: to_user.id, period_id: period.id, codes: codes.join(","), count: codes.count,  source_type: 1, attack_user_id: current_user.id)
              all_codes += codes
            end
            Mammon::UserCode.create!(user_id: current_user.id, period_id: period.id, codes: all_codes.join(","), count: all_codes.count,  source_type: 2)
            period.add_user_codes(current_user, all_codes)
            res = {
              "execResult": true,
              "execMsg": "",
              "execData": {data: {from_user: current_user, to_users: to_users, codes: all_codes, count: all_codes.size}, num: user_card.card.num},
              "execDatas": [],
              "execErrCode": "200"
            }
          end

        end
      else
        res = {
          "execResult": false,
          "execMsg": "卡牌数量不足",
          "execData": {},
          "execDatas": [],
          "execErrCode": "500"
        }
      end
    else
      res = {
        "execResult": false,
        "execMsg": "活动未开启",
        "execData": {},
        "execDatas": [],
        "execErrCode": "500"
      }
    end
    res
  end

  def self.danqiang_action to_user_id, current_user, period, user_card, is_program = false
    if to_user_id
      key = "mammon_period:user_codes_key:#{period.id}:user_id:#{to_user_id}"
    else
      key = self.get_to_user_key period, current_user
    end

    unless key
      return {
        "execResult": false,
        "execMsg": "当前没有可掠夺对象",
        "execData": {},
        "execDatas": [],
        "execErrCode": "500"
      }
    end

    to_user = User.where(id: key.split("user_id:").last).first

    if $redis.decrby(period.user_status_key(to_user, "jiahuo"), 1).to_i == 0 #有嫁祸buf
      return danqiang_action nil, current_user, period, user_card, is_program
    else
      $redis.incrby(period.user_status_key(to_user, "jiahuo"), 1)
    end

    if $redis.decrby(period.user_status_key(to_user, "fanqiang"), 1).to_i == 0 #有嫁祸buf
      # return danqiang_action current_user.id, to_user, period, user_card
      # to_user_id, current_user_id, period_id, user_card_id
      CardJob.set(wait: 5.seconds).perform_later(current_user.id, to_user.id, period.id, user_card.id)
    else
      $redis.incrby(period.user_status_key(to_user, "fanqiang"), 1)
    end

    if $redis.decrby(period.user_status_key(to_user, "xiaohao"), 1).to_i == 0 #有嫁祸buf
      return {
      "execResult": false,
      "execMsg": "对方拥有消耗，需要再次消耗1张相同技能牌",
      "execData": {user_id: to_user.id},
      "execDatas": [],
      "execErrCode": "600"
    }
    else
      $redis.incrby(period.user_status_key(to_user, "xiaohao"), 1)
    end

    zengfu = 1
    if $redis.decrby(period.user_status_key(current_user, "zengfu"), 1).to_i == 0 #有增幅buf
      zengfu = 1 + Mammon::Card.where(num: "zengfu").last&.effect_percent
    else
      $redis.incrby(period.user_status_key(current_user, "zengfu"), 1)
    end
    count = ($redis.smembers(key).size * user_card.card.effect_percent * zengfu).ceil

    codes = []
    if count > 0
      codes = period.pop_user_codes(to_user, count)
      period.add_user_codes(current_user, codes)
    end
    attack_record = Mammon::AttackRecord.create!(from_user_id: current_user.id, to_user_id: key.split("user_id:").last, period_id: period.id, codes: codes.join(","), card_id: user_card.card_id, is_program: is_program)
    Mammon::UserCode.create!(user_id: current_user.id, period_id: period.id, codes: codes.join(","), count: codes.count,  source_type: 2)
    Mammon::UserCode.create!(user_id: to_user.id, period_id: period.id, codes: codes.join(","), count: codes.count,  source_type: 1, attack_user_id: current_user.id)

    res = {
      "execResult": true,
      "execMsg": "",
      "execData": {data: {attack_record: attack_record, from_user: current_user, to_user: to_user, codes: codes, count: codes.size}, num: user_card.card.num},
      "execDatas": [],
      "execErrCode": "200"
    }
  end

  #获取可以攻击的用户key
  def self.get_to_user_key period, current_user
    keys = $redis.keys("mammon_period:user_codes_key:#{period.id}:user_id:*").shuffle
    keys.each do |key|
      if $redis.smembers(key).size > 0 && key.split(":").last != current_user.id
        return key
      end
    end
    return nil
  end

  #按概率随机获取卡牌
  def self.lottery_cards count
    ids = []
    res = Mammon::Card.active.where("percent >= 1").pluck(:id)
    Mammon::Card.active.where("percent < 1").each  do |c|
      ids +=  Array.new((c.percent * 1000).to_i, c.id)
    end
    (res + ids.sample(count)).flatten.first(count)
  end


  def self.get_card_by_num num
    Rails.cache.fetch("card_json_#{num}", expires_in: 60){
      Mammon::Card.where(num: num).last.as_json
    }
  end
end
