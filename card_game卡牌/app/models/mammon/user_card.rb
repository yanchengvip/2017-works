class Mammon::UserCard < ApplicationRecord
  belongs_to :card,class_name: 'Mammon::Card',foreign_key: :card_id

  #系统为拥有卡牌 并且 没有使用卡牌记录的用户自动执行卡牌攻击
  def self.auto_use_card
    _t = Time.now
    Rails.logger.info("#{Date.today.to_s}:自动执行卡牌攻击开始")
    danqiang = Mammon::Card.where(num: "danqiang").last&.id
    period = Mammon::Period.current
    if danqiang && period
      all_user_ids = Mammon::UserCard.where(card_id: danqiang, period_id: period.id).where("count > 0").pluck(:user_id).uniq
      attack_user_ids = Mammon::AttackRecord.where(period_id: period.id).pluck(:from_user_id).uniq
      ids = (all_user_ids - attack_user_ids)
      if (10000 - attack_user_ids.size) > 0
        User.where(id: ids.sample(10000 - attack_user_ids.size) ).each do |user|
          # UserCardJob.set(wait: 1.seconds).perform_later(user.id, danqiang)
          res = Mammon::Card.use(user, card_id, nil, true)
          Rails.logger.info("user:#{user.id}---\r\n#{res}")
        end
      end
    end
    Rails.logger.info("#{Date.today.to_s}:自动执行卡牌攻击开始结束:耗时:#{Time.now - _t}")
  end

  #首次登陆赠送2张技能牌给用户
  def self.add_card_to_user(current_user, period)
    if $redis.incrby("login_card:#{current_user.id}:#{period.id}", 1) == 1

      danqiang = Rails.cache.fetch("card_danqian", expires_in: 60){
        Mammon::Card.where(num: "danqiang").last&.id
      }
      huhuan = Rails.cache.fetch("card_huhuan", expires_in: 60){
        Mammon::Card.where(num: "huhuan").last&.id
      }
      card_ids = []
      if rand(100) > 50
        card_ids = [danqiang, danqiang]
      else
        card_ids = [danqiang, huhuan]
      end
      card_ids.each do |card_id|
        card = self.where(:user_id => current_user.id,:card_id => card_id,:period_id => period.id).lock!.first
        self.add_invite_card card, current_user, card_id, period
      end
    end
    $redis.expire("login_card:#{current_user.id}:#{period.id}", 24 * 3600)
  end

  def self.add_card_to_users mobiles
    period = Mammon::Period.current
    if period
      User.where(login_name: mobiles).each do |u|
        Mammon::Card.all.each do |c|
          muc = Mammon::UserCard.find_by(user_id: u.id, card_id: c.id, period_id: period.id)
          unless muc
            Mammon::UserCard.create(user_id: u.id, card_id: c.id, period_id: period.id, count: 10000, status: 0)
          else
            muc.update_attributes(count: muc.count + 10000)
          end
        end
      end
    end
  end


  def self.add_invite_card card, user, card_id, period, add_count = 1
    if card
      card.update(:count => card.count + add_count)
    else
      self.create(:user_id => user.id,:card_id => card_id,:period_id => period.id,:count => add_count,:status => 0)
    end
  end
  #邀请随随机送2张技能牌
  def self.give_card user, invite_user, period, count,time, invite_flag
    card_ids = Mammon::Card.lottery_cards(count)
    card_array = []
    card_ids.each do |card_id|
      card_by_id = Mammon::Card.find(card_id)
      card_array << card_by_id
      Mammon::InviteRecord.create(:user_id => user.id,:invite_user_id => invite_user.id,:period_id => period.id,:prize_type => card_by_id.num,:prize_count => 1) if invite_flag
      card = self.find_by(:user_id => user.id,:card_id => card_id,:period_id => period.id)
      card_invite = self.find_by(:user_id => invite_user.id,:card_id => card_id,:period_id => period.id)
      self.add_invite_card card,user,card_id,period if invite_flag
      if Time.now - time < 2*3600
        self.add_invite_card card_invite,invite_user,card_id,period
      end
    end
    result_hash = Hash.new 0
    card_array.each do |card|
      result_hash[card.num] += 1
    end
    # period.incrby_invite_data(user,result_hash, 0, 0)
    # period.incrby_invite_data(invite_user,result_hash, 0, 0, 0)
    # puts "1"

    result_hash
  end

  #邀请随随机送2张技能牌(每日首位邀请奖励)
  def self.first_day_card user, period, count
    card_ids = Mammon::Card.lottery_cards(count)
    card_array = []
    card_ids.each do |card_id|
      card_by_id = Mammon::Card.find(card_id)
      card_array << card_by_id
      card = self.find_by(:user_id => user.id,:card_id => card_id,:period_id => period.id)
      self.add_invite_card card,user,card_id,period
    end
    result_hash = Hash.new 0
    card_array.each do |card|
      result_hash[card.num] += 1
    end
    result_hash
    # period.incrby_invite_data(user,result_hash, 0, 0)
  end

end
