# ## Schema Information
#
# Table name: `trades` # 交易表
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`account_id(账号ID)`**     | `integer`          | `default(0)`
# **`mt4_account(MT4账号)`**       | `string(255)`      |
# **`order_code(订单号)`**    | `string(255)`      |
# **`symbol(交易品种  字母表示)`**       | `string(255)`      |
# **`digits(交易品种 数字表示)`**      | `integer`          | `default(0)`
# **`cmd(0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop, 6 = 入金 / 出金, 7 = 信用)`**                                                                                        | `integer`          |
# **`volume(手数)`**   | `integer`          | `default(0)`
# **`open_time(开仓时间)`**    | `datetime`         |
# **`open_price(开仓价格)`**     | `decimal(16, 6)`   | `default(0.0)`
# **`sl(止亏)`**       | `decimal(16, 6)`   | `default(0.0)`
# **`tp(止盈)`**       | `decimal(16, 6)`   | `default(0.0)`
# **`close_time(平仓时间;时间="1970-01-01 00:00:00"为在仓单，反之则为平仓单)`**                                          | `datetime`         | `default(Thu, 01 Jan 1970 00:00:00 CST +08:00)`
# **`close_price(平仓价格)`**      | `decimal(16, 6)`   | `default(0.0)`
# **`commission(佣金)`**   | `decimal(16, 6)`   | `default(0.0)`
# **`profit(利润)`**   | `decimal(16, 6)`   | `default(0.0)`
# **`source(订单来源 1：跟单，2：跟人/策略,3:自主交易)`**                     | `integer`          | `default(0)`
# **`dealer_id(券商表dealers表ID)`**             | `integer`          | `default(0)`
# **`dealer_type(关联券商类型dealer_type)`**                   | `integer`          | `default(0)`
# **`tactic_flag(策略唯一标识符)`**         | `string(255)`      |
# **`trade_id(跟单的交易表的ID)`**        | `integer`          | `default(0)`
# **`request_ip(登录ip地址)`**       | `string(255)`      |
# **`active(软删)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `account_dealer_index`:
#     * **`account_id`**
#     * **`dealer_id`**
# * `index_trades_on_close_time`:
#     * **`close_time`**
# * `index_trades_on_mt4_account`:
#     * **`mt4_account`**
# * `index_trades_on_order_code` (_unique_):
#     * **`order_code`**
# * `index_trades_on_tactic_flag`:
#     * **`tactic_flag`**
#

class Trade < ApplicationRecord
  has_one :booking_trade
  belongs_to :account
  belongs_to :dealer
  attr_accessor :margin
  after_create :generate_order_code
  after_create :master_trade_for_account
  after_save :master_trade_close_for_account, if: Proc.new { |trade| trade.close_time_changed? and trade.dealer_type == 1 and trade.account.is_master }

  #创建交易
  def self.trade_deal account, params
    account = account.lock!
    margin = Trade.margin_use account, params
    return {status: 500, msg: '货币对有误！', data: {}} if margin <= 0
    if account.margin_free < margin
      return {status: 500, msg: '保证金不足！', data: {}}
    end

    trade = Trade.create!(account_id: account.id, mt4_account: account.mt4_account, dealer_id: account.dealer_id,
                          dealer_type: account.dealer_type, margin: margin, symbol: params[:symbol], digits: params[:digits], cmd: params[:cmd],
                          volume: params[:volume], open_time: params[:open_time], open_price: params[:open_price],
                          sl: params[:sl], tp: params[:tp], source: params[:source],
                          tactic_flag: params[:tactic_flag], trade_id: params[:trade_id])

    account.update_attributes!(margin: account.margin + margin, margin_free: account.margin_free - margin)
    return {status: 200, msg: '交易成功！',
            data: {trade_id: trade.id, open_price: trade.open_price, order_code: trade.order_code, margin: margin}}
  end


  #保证金
  def self.margin_use account, params
    symbol = params[:symbol].upcase
    open_price = params[:open_price]
    currency_count = Trade.currency_quantity symbol #合约量
    if symbol.index('USD') == 0
      #美元在前货币对，保证金=合约量（100000）*手数/杠杆
      margin = currency_count * (params[:volume] * 0.01) / account.leverage
    elsif symbol.index('USD').nil?
      #交叉货币对，保证金=合约量（100000）*手数*前面货币兑美元汇率/杠杆
      c = symbol[0..2]+'USD'
      c2 = 'USD' + symbol[0..2]
      ask1, bid1 = Trade.get_ask_and_bid c
      ask2, bid2 = Trade.get_ask_and_bid c2
      if bid1 > 0
        bid = bid1
      elsif bid1 <= 0 && bid2 > 0
        bid = (1/bid2).round(5)
      else
        return 0
      end
      margin = currency_count * (params[:volume] * 0.01) * bid / account.leverage
    else
      #美元在后货币对，保证金=合约量（100000）*手数*市价/杠杆
      margin = currency_count * (params[:volume] * 0.01) * open_price / account.leverage
    end
    return margin
  end


  #简单交易
  def self.trade_simple current_account, trade_params
    begin
      ask, bid = Trade.get_ask_and_bid trade_params[:symbol]
      return {status: 500, msg: '成交价格不能小于0', data: {}} if ask <= 0 || bid <= 0
      tp = {symbol: trade_params[:symbol], digits: trade_params[:digits], cmd: trade_params[:cmd],
            open_time: Time.now, sl: trade_params[:sl], tp: trade_params[:tp], source: trade_params[:source]
      }
      ActiveRecord::Base.transaction do
        case trade_params[:cmd].to_i
          when 0
            #买
            volume = (trade_params[:margin].to_f / ask).round(2)
            return {status: 500, msg: '保证金不足', data: {}} if volume <= 0
            res = Trade.trade_deal current_account, tp.merge(open_price: ask, volume: volume)
          when 1
            #卖
            volume = (trade_params[:margin].to_f / bid).round(2)
            return {status: 500, msg: '保证金不足', data: {}} if volume <= 0
            res = Trade.trade_deal current_account, tp.merge(open_price: bid, volume: volume)
        end
        return res
      end
    rescue Exception => e
      p e
      Rails.logger.info e
      return {status: 500, msg: '交易失败', data: {error: e}}
    end
  end


  #复制跟单交易
  def self.trade_copy current_account, trade_params
    begin
      t = Trade.includes(:account).where(id: trade_params[:trade_id], dealer_type: 1, close_time: '1970-01-01 00:00:00').first
      return {status: 500, msg: '订单不能被复制，已平仓或者不是大师的订单', data: {}} if t.nil? || !t.account&.is_master
      ask, bid = Trade.get_ask_and_bid trade_params[:symbol]
      return {status: 500, msg: '成交价格不能小于0', data: {}} if ask <= 0 || bid <= 0
      tp = {symbol: trade_params[:symbol], digits: trade_params[:digits], cmd: trade_params[:cmd],
            open_time: Time.now, source: trade_params[:source],
            trade_id: trade_params[:trade_id].to_i, volume: trade_params[:volume].to_i
      }
      ActiveRecord::Base.transaction do
        case trade_params[:cmd].to_i
          when 0
            #买
            return {status: 500, msg: '手数不能为0', data: {}} if trade_params[:volume].to_i <= 0
            res = Trade.trade_deal current_account, tp.merge(open_price: ask)
          when 1
            #卖
            return {status: 500, msg: '手数不能为0', data: {}} if trade_params[:volume].to_i <= 0
            res = Trade.trade_deal current_account, tp.merge(open_price: bid)
        end
        return res
      end
    rescue Exception => e
      p e
      Rails.logger.info e
      return {status: 500, msg: '交易失败', data: {error: e}}
    end
  end


  #平仓
  def trade_close account
    begin
      return {status: 200, msg: '不能重复平仓', data: {}} if self.close_time.strftime('%Y-%d-%m %H:%M:%S') != '1970-01-01 00:00:00'
      ask, bid = Trade.get_ask_and_bid self.symbol.upcase
      close_price = bid if [0, 2, 4].include? self.cmd #做多平仓
      close_price = ask if [1, 3, 5].include? self.cmd #做空平仓
      res = self.profit_count close_price
      return {status: 500, msg: '平仓失败,当前价格不能为0', data: {error: e}} if res[:status] == 0
      profit = res[:profit]
      self.with_lock do
        account = account.lock!
        self.update_attributes!(close_time: Time.now, profit: profit, close_price: bid)
        account.update_attributes!(balance: account.balance + profit, margin_use: account.margin - self.margin)
      end
      return {status: 200, msg: '平仓成功', data: {}}
    rescue Exception => e
      p e
      Rails.logger.info e
      return {status: 500, msg: '平仓失败', data: {error: e}}
    end

  end

  # 平仓 计算收益
  def profit_count close_price
    symbol = self.symbol.upcase
    open_price = self.open_price
    volume = self.volume.to_f
    currency_count = Trade.currency_quantity symbol #合约量
    if symbol.index('USD') == 0
      #美元在前货币对，盈亏 = （平仓价-开仓价）*手数*合约量/平仓价
      profit = (close_price - open_price) * volume * currency_count / close_price
    elsif symbol.index('USD').nil?
      #交叉货币对，盈亏 = （平仓价-开仓价）*手数*合约量*后面货币兑美元汇率
      c = symbol[3..5]+'USD'
      c2 = 'USD' + symbol[3..5]
      ask1, bid1 = Trade.get_ask_and_bid c
      ask2, bid2 = Trade.get_ask_and_bid c2
      if bid1 > 0
        bid = bid1
      elsif bid1 <= 0 && bid2 > 0
        bid = (1/bid2).round(5)
      else
        return {status: 0, bid: bid2}
      end
      profit = (close_price - open_price) * volume * currency_count * bid
    else
      #美元在后货币对，盈亏 = （平仓价-开仓价）*手数*合约量
      profit = (close_price - open_price) * volume * currency_count
    end
    return {status: 1, profit: profit}
  end


  #当前买入价和卖出价
  def self.get_ask_and_bid symbol
    ask = $redis.lindex("#{symbol}_ASK", 0).to_f #当前买价
    bid = $redis.lindex("#{symbol}_BID", 0).to_f #当前卖价
    return ask, bid, symbol
  end

  #货币行情中 当日最低/最高价和涨跌点数、涨跌幅。
  def self.max_min_price symbol
    begin
      ask, bid, symbol = Trade.get_ask_and_bid symbol
      bid_open = $redis.hget("#{Time.now.strftime('%Y-%m-%d')}-wisdom-open-price", symbol).to_f #当天开盘价
      bid_max = $redis.lindex(symbol+'_BID_DAY_MAX', 0).to_f #当天最高价
      bid_min = $redis.lindex(symbol+'_BID_DAY_MIN', 0).to_f #当天最低价
      day_count = ((bid - bid_open) / 10).round(5) #涨跌点数
      day_limit = ((bid - bid_open) / bid_open).round(5) if bid_open != 0 #涨跌幅
      return {status: 200, msg: '成功', data: {day_count: day_count, day_limit: day_limit, bid_min: bid_min,
                                             bid_max: bid_max}}

    rescue Exception => e
      return {status: 500, msg: '失败', data: {error: e}}
    end

  end


  #合约量
  def self.currency_quantity currency
    if currency == 'XAGUSD'
      return 1000
    elsif currency == 'XAUUSD'
      return 100
    else
      return 100000
    end
  end


  private

  def generate_order_code
    self.update_attributes(order_code: SecureRandom.uuid) if self.dealer_type == 1
  end


  #牛人下单后，为跟随的账户下单
  def master_trade_for_account
    begin
      master = self.account
      if master.is_master && master.dealer_type == 1
        master.accounts.each do |account|
          ask, bid = Trade.get_ask_and_bid self.symbol
          return {status: 500, msg: '成交价格不能小于0', data: {}} if ask <= 0 || bid <= 0
          trade = {symbol: self.symbol, digits: self.digits, cmd: self.cmd,
                   open_time: Time.now, sl: self.sl, tp: self.tp, source: 2, trade_id: self.id,
                   volume: self.volume
          }
          ActiveRecord::Base.transaction do
            if [0, 2, 4].include? self.cmd
              #做多
              res = Trade.trade_deal account, trade.merge(open_price: ask)
            end
            if [1, 3, 5].include? self.cmd
              #做空
              res = Trade.trade_deal account, trade.merge(open_price: bid)
            end
          end

        end
      end
    rescue Exception => e
      p e
      Rails.logger.info e
    end

  end

  #牛人平仓后，为跟随的账户平仓
  def master_trade_close_for_account
    begin
      trades = Trade.includes(:account).where(trade_id: self.id)
      trades.each do |t|
        t.trade_close t.account
      end
    rescue Exception => e

    end
  end
end
