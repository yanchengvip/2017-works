class Promotion::RedPackage < ApplicationRecord
  belongs_to :red_package_rule
  has_many :red_package_items

  belongs_to :table, polymorphic: true

  self.xml_options = {
      include: {
        table: {}
      }
  }.freeze

  def init_redis()
    $redis.del(redis_key)
    $redis.lpush(redis_key, cash_items)
    self.update(status: 0)
  end

  def cash_items
    res = []
    red_package_rule.red_package_rule_items.each do |red_package_rule_item|
      red_package_rule_item.count.times do
        res << red_package_rule_item.chest_prize_id
      end
    end
    res.shuffle
  end

  def redis_key
    "Promotion::RedPackage:#{self.id}:redis_queue"
  end

  def draw_count_user_key current_user
    "Promotion::RedPackage:#{self.id}:user_count:#{current_user.id}"
  end

  def rsa_private_sign(data, private_key)
    pri = OpenSSL::PKey::RSA.new(Base64.decode64 private_key)
    sign = pri.sign('sha1', data.force_encoding("utf-8"))
    signature = Base64.encode64(sign)
    signature = signature.delete("\n").delete("\r")
    return signature
  end

  def draw current_user
    if self.table_type == "GameLeague" && !BattleUserRecord.where(battle_id: GameBattleRecord.where(league_id: self.table_id).pluck(:id), user_id: current_user.id).exists?
      res = {"execResult"=>false, "execMsg"=>"", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"503"}
      return res
      # battle_ids = GameBattleRecord.where(league_id: params[:table_id]).pluck(:id)
        # user_ids = BattleUserRecord.where(battle_id: battle_ids)
    end
    res = {}
    if (count = $redis.incrby(draw_count_user_key(current_user), 1)) <= self.red_package_rule.claim_times_max
      if(chest_prize_id = $redis.lpop(redis_key))
        chest_prize = ChestPrize.find(chest_prize_id)
        begin
          chest_prize_id = chest_prize_id.to_i
          account_ticket = current_user.account_ticket
          account_ticket.with_lock do
            self.red_package_items.create!(user_id: current_user.id, chest_prize_id: chest_prize_id)


            # PRIZE_TYPE = {1 => '实物', 2 => '入场券', 3 => '兑奖券', 5 => '宝箱券', 6 => '现金券', 7 => '话费', 9 => '京东卡', 10 => '现金'}
            if chest_prize.prize_type == 6 #'现金券'
              ChestRecordItem.create!( chest_prize_id: chest_prize_id, user_id: current_user.id, prize_type: chest_prize.prize_type, is_recovery: false)

              event_ids = chest_prize.event_id.to_s
              ihaveu_login_name = current_user.ihaveu_login_name
              rsa_private_key = SYSTEMCONFIG[:ihaveu][:rsa_private_key]
              params = {
                id: event_ids,
                login: ihaveu_login_name,
                timestamp: Time.now.to_s,
              }
              params[:sign] = rsa_private_sign("id=#{params[:id]}&login=#{params[:login]}&timestamp=#{params[:timestamp]}", rsa_private_key)
              res = Faraday.new.post(SYSTEMCONFIG[:ihaveu][:host] + "/auction/events/create_voucher", params).body

            elsif chest_prize.prize_type == 10 #'现金'
              AccountTicketBalanceDetail.create!( user_id: current_user.id, fund: chest_prize.num, trad_type: 2)
              account_ticket.update!(balance: account_ticket.balance + chest_prize.num )
            elsif chest_prize.prize_type == 5 #'宝箱券'
              account_ticket.update!(treasure_total_amount: account_ticket.treasure_total_amount + chest_prize.num )
              account_ticket.account_ticket_details.create!(user_id: current_user.id, type: 3, fund: chest_prize.num, wealth_type: 2, trad_type: 5)
            end
          end
          res = {"execResult"=>true, "execMsg"=>"", "execData"=>{amount: chest_prize.prize_type == 5 ? chest_prize.num.round(0) : chest_prize.num, prize_type: chest_prize.prize_type}, "execDatas"=>[], "execErrCode"=>"200"}
        rescue Exception => e

          $redis.decrby(draw_count_user_key(current_user), 1)
          $redis.lpush(redis_key, chest_prize_id)
          res = {"execResult"=>false, "execMsg"=>"系统错误", "execData"=>{error: e.as_json}, "execDatas"=>[], "execErrCode"=>"502"}
        end
      else
        res = {"execResult"=>false, "execMsg"=>"红包已抢完", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"500"}
      end
    else
      $redis.decrby(draw_count_user_key(current_user), 1)
      res = {"execResult"=>false, "execMsg"=>"超过最大抽取次数", "execData"=>{}, "execDatas"=>[], "execErrCode"=>"501"}
    end
    res
  end

end
