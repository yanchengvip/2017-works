class AccountTicketBalanceDetail < ApplicationRecord
  belongs_to :user

  TRADTYPE = {
      1 => '提现',
      2 => '领取红包',
      3 => '现金红包回收',
      4 => "宝箱奖品",
      5 => "注册赠送",
      6 => '财神福利',
      7 => '邀请获得'
  }


  def self.user_mammon_total_amount user_id
    Rails.cache.fetch("mammon_total_amount:user_id:#{user_id}", expires_in: 15) {
      self.active.where(user_id: user_id, trad_type: [5,6,7])&.sum{|bd| bd.fund}
    }
  end

  #邀请送现金
  def self.give_account_ticket invite_id,invite_user_id,period

    if flag = InviteRelationship.where(invite_user_id:  invite_id).count <= (Setting.value("user_invite_money_count") || 50).to_i
      self.create(:user_id => invite_id,:trad_type => 7,:fund => period.invite_reward)
      $redis.decrby( period.redis_cash_keys, period.invite_reward.to_i )
      a1 = AccountTicket.lock.find_by(user_id: invite_id)
      a1.balance +=  period.invite_reward
      a1.save!
    end

    self.create(:user_id => invite_user_id,:trad_type => 5, :fund => period.been_invite_reg_reward)
    $redis.decrby( period.redis_cash_keys, period.been_invite_reg_reward.to_i )
    a2 = AccountTicket.lock.find_by(user_id: invite_user_id)
    a2.balance +=  period.been_invite_reg_reward
    a2.save!
    flag
  end


end
