# ## Schema Information
#
# Table name: `booking_trades` # 挂单表
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id()`**             | `integer`          | `not null, primary key`
# **`account_id(账号ID)`**  | `integer`          | `default(0)`
# **`trade_type(1:建仓；2：平仓)`**      | `integer`          | `default(0)`
# **`mt4_account(MT4账号)`**   | `string(255)`      |
# **`symbol(交易品种  字母表示)`**   | `string(255)`      |
# **`digits(交易品种 数字表示)`**  | `integer`          | `default(0)`
# **`volume(手数)`**       | `integer`          | `default(0)`
# **`deal_price(成交价格)`**  | `decimal(16, 6)`   | `default(0.0)`
# **`booking_price(挂单价格)`**    | `decimal(16, 6)`   | `default(0.0)`
# **`sl(止亏)`**           | `decimal(16, 6)`   | `default(0.0)`
# **`tp(止盈)`**           | `decimal(16, 6)`   | `default(0.0)`
# **`source(订单来源 1：跟单，2：跟人/策略,3:自主交易)`**                 | `integer`          | `default(0)`
# **`dealer_id(券商表dealers表ID)`**         | `integer`          | `default(0)`
# **`dealer_type(关联券商类型dealer_type)`**               | `integer`          | `default(0)`
# **`tactic_flag(策略唯一标识符)`**     | `string(255)`      |
# **`trade_id(跟单的交易表的ID)`**    | `integer`          | `default(0)`
# **`request_ip(登录ip地址)`**   | `string(255)`      |
# **`active(软删)`**       | `boolean`          | `default(TRUE)`
# **`created_at()`**     | `datetime`         | `not null`
# **`updated_at()`**     | `datetime`         | `not null`
# **`status(状态: -1 = 撤单,0 = 正常，1 = 成交)`**                  | `integer`          | `default(0)`
# **`expire_time(挂单有效期)`**   | `datetime`         |
# **`follow_trade_id(被跟随订单的trades表的ID)`**                  | `integer`          |
#
# ### Indexes
#
# * `b_account_dealer_index`:
#     * **`account_id`**
#     * **`dealer_id`**
# * `index_booking_trades_on_mt4_account`:
#     * **`mt4_account`**
# * `index_booking_trades_on_trade_id`:
#     * **`trade_id`**
#

class BookingTrade < ApplicationRecord
  belongs_to :account
  belongs_to :trade
  after_create :create_booking_trade_job
  after_create :create_expire_time

  def check_price
    res = false
    if self.status == 0 && self.expire_time >= Time.now
      # ask = 2 #当前买价
      # bid = 1 #当前卖价
      ask, bid = Trade.get_ask_and_bid params[:symbol]
      if self.trade_type == 2 && ask <= self.booking_price
        #BuyLimit(做多)
        res = booking_trade_deal ask
      elsif self.trade_type == 3 && bid >= self.booking_price
        #SellLimit(做空)
        res = booking_trade_deal bid
      elsif self.trade_type == 4 && ask >= self.booking_price
        #BuyStop(做多)
        res = booking_trade_deal ask
      elsif self.trade_type == 5 && bid <= self.booking_price
        #SellStop(做空)
        res = booking_trade_deal bid
      elsif self.trade_type == 8 && bid >= self.booking_price
        #平仓
      end
    else
      res = true
    end

    return res
  end


  #创建挂单
  def self.booking_trade_create params, account
    #ask = 1 #当前买价
    #bid = 1 #当前卖价
    ask, bid = Trade.get_ask_and_bid params[:symbol]
    case params[:trade_type].to_i
      when 2
        #做多
        trade_type = 2 if ask > params[:price].to_f
        trade_type = 4 if ask < params[:price].to_f
      when 3
        #做空
        trade_type = 3 if bid > params[:price].to_f
        trade_type = 5 if bid < params[:price].to_f
      else
        return false
    end
    begin
      BookingTrade.create!(account_id: account.id, trade_type: trade_type, mt4_account: account.mt4_account,
                           symbol: params[:symbol], digits: params[:digits], volume: params[:volume].to_f * 100,
                           booking_price: params[:price], sl: params[:sl], tp: params[:tp], source: params[:source],
                           expire_time: params[:expire_time], dealer_id: account.dealer_id,
                           dealer_type: account.dealer_type, status: 0)
      return true
    rescue Exception => e
      p e
      Rails.logger.info(e)
      return false
    end
  end


  private

  #挂单成交
  def booking_trade_deal current_price
    begin
      self.with_lock do
        return true if self.status != 0
        params = {symbol: self.symbol, digits: self.digits, cmd: self.trade_type, volume: self.volume,
                  open_price: current_price, open_time: Time.now, sl: self.sl, tp: self.tp, source: self.source,
                  dealer_id: self.dealer_id, dealer_type: self.dealer_type
        }
        res = Trade.trade_deal self.account, params
        if res[:status] == 500
          self.update_attributes!(status: -2)
          return true
        end
        if res[:status] == 200
          self.update_attributes!(status: 1, deal_price: current_price, trade_id: res[:data][:trade_id])
          return true
        end
      end
    rescue Exception => e
      Rails.logger.info(e)
      return false
    end

  end


  def create_booking_trade_job
    BookingTradeCheckJob.set(wait: 1.seconds).perform_later(self.id)
  end

  def create_expire_time
    self.update_attributes(expire_time: Time.now.end_of_day) if self.expire_time.nil?
  end
end
