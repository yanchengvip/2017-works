class Virtual::Trade < ApplicationRecord
  belongs_to :account
  after_create :generate_identifier
  after_create :pending_trade_jobs, if: Proc.new { |trade| [2, 3, 4, 5].include?(trade.cmd) }


  #用户类型
  TYPPEE = {0 => '普通用户', 2 => '交易员'}
  #交易类型
  CMD = {0 => 'BUY', 1 => 'SELL', 2 => 'BuyLimit', 3 => 'SellLimit', 4 => 'BuyStop', 5 => 'SellStop'}


  #挂单交易 由sidekiq执行调用
  def pending_trade_by_job
    res = false
    if self.expiration.present? && self.expiration >= Time.now
      ask, bid = Virtual::Trade.get_ask_and_bid self.symbol
      if self.cmd == 2 && bid <= self.price.to_f
        #BuyLimit(做多，在当前价格下方挂买单)
        res = pending_trade_deal({symbol: self.symbol, volume: self.volume, cmd: 0})
      elsif self.cmd == 3 && ask >= self.price.to_f
        #SellLimit(做空，在当前价格上方挂卖单)
        res = pending_trade_deal({symbol: self.symbol, volume: self.volume, cmd: 1})
      elsif self.cmd == 4 && bid >= self.price.to_f
        #BuyStop(做多，在当前价格上方挂买单)
        res = pending_trade_deal({symbol: self.symbol, volume: self.volume, cmd: 0})
      elsif self.cmd == 5 && ask <= self.price.to_f
        #SellStop(做空 在当前价格下方挂卖单)
        res = pending_trade_deal({symbol: self.symbol, volume: self.volume, cmd: 1})
      end
    else
      res = true
    end

    return res
  end

  #平仓
  def trade_close account
    begin
      return {status: 500, msg: '不能重复平仓', data: {}} if self.close_time.strftime('%Y-%d-%m %H:%M:%S') != '1970-01-01 00:00:00'
      res = self.profit_count
      return {status: 501, msg: '平仓失败,当前价格不能为0', data: {error: e}} if res[:status] == 0
      self.with_lock do
        account = account.lock!
        self.update_attributes!(close_time: Time.now, profit: res[:profit], close_price: res[:close_price])
        account.update_attributes!(balance: account.balance.to_f + res[:profit],
                                   margin: account.margin.to_f - self.margin.to_f,
                                   margin_free: account.margin_free + self.margin)
      end
      return {status: 200, msg: '平仓成功', data: {}}
    rescue Exception => e
      p e
      Rails.logger.info e
      return {status: 502, msg: '平仓失败', data: {error: e}}
    end

  end

  # 平仓 计算收益
  def profit_count
    symbol = self.symbol.upcase
    open_price, volume = self.open_price.to_f, self.volume.to_i
    ask, bid = Virtual::Trade.get_ask_and_bid symbol
    close_price = bid if self.cmd == 0 #做多平仓
    close_price = ask if self.cmd == 1 #做空平仓
    currency_count = Virtual::Trade.currency_quantity symbol #合约量
    if close_price <= 0
      return {status: 0, msg: '平仓价格不能为0', profit: 0, close_price: close_price}
    end
    if symbol.index('USD') == 0
      #美元在前货币对，盈亏 = （平仓价-开仓价）*手数*合约量/平仓价
      profit = (close_price - open_price) * volume * currency_count / close_price
    elsif symbol.index('USD').nil?
      #交叉货币对，盈亏 = （平仓价-开仓价）*手数*合约量*后面货币兑美元汇率
      c = symbol[3..5]+'USD'
      c2 = 'USD' + symbol[3..5]
      ask1, bid1 = Virtual::Trade.get_ask_and_bid c
      ask2, bid2 = Virtual::Trade.get_ask_and_bid c2
      if bid1 > 0
        bid = bid1
      elsif bid1 <= 0 && bid2 > 0
        bid = (1/bid2).round(5)
      else
        return {status: 0, close_price: bid2}
      end
      profit = (close_price - open_price) * volume * currency_count * bid
    else
      #美元在后货币对，盈亏 = （平仓价-开仓价）*手数*合约量
      profit = (close_price - open_price) * volume * currency_count
    end
    return {status: 1, profit: profit.to_f, close_price: close_price.to_f}
  end


  class << self
    #手数交易 params= {symbol: '',volume:1, cmd: 1,sl: '',tp: ''}
    def trade_by_volumes current_account, params
      begin
        ActiveRecord::Base.transaction do
          return Virtual::Trade.trade_deal current_account, params
        end
      rescue Exception => e
        p e
        Rails.logger.info e
        return {status: 505, msg: '交易失败', data: {error: e}}
      end
    end


    #创建交易
    def trade_deal account, params
      account = account.lock!
      margin, open_price = Virtual::Trade.margin_use account, params
      return {status: 502, msg: '货币对有误！', data: {}} if margin.to_f <= 0 || open_price.to_f <= 0
      return {status: 503, msg: '保证金不足！', data: {}} if account.margin_free < margin
      trade = Virtual::Trade.create!(account_id: account.id, margin: margin, cmd: params[:cmd], symbol: params[:symbol], volume: params[:volume], open_time: Time.now, open_price: open_price, sl: params[:sl], tp: params[:tp])
      account.update_attributes!(margin: account.margin + margin, margin_free: account.margin_free - margin)
      return {status: 200, msg: '交易成功！', data: {trade_id: trade.id, open_price: trade.open_price, margin: margin}}
    end


    #保证金
    def margin_use account, params
      symbol = params[:symbol].upcase
      volume, cmd = params[:volume].to_i, params[:cmd].to_i
      ask, open_price = get_ask_and_bid(symbol) if cmd == 0 #买
      open_price, bid = get_ask_and_bid(symbol) if cmd == 1 #卖
      currency_count = Virtual::Trade.currency_quantity symbol #合约量
      if symbol.index('USD') == 0
        #美元在前货币对，保证金=合约量（100000）*手数/杠杆
        margin = currency_count * (volume * 0.01) / account.leverage
      elsif symbol.index('USD').nil?
        #交叉货币对，保证金=合约量（100000）*手数*前面货币兑美元汇率/杠杆
        c = symbol[0..2]+'USD'
        c2 = 'USD' + symbol[0..2]
        ask1, bid1 = get_ask_and_bid c
        ask2, bid2 = get_ask_and_bid c2
        if bid1 > 0
          bid = bid1
        elsif bid1 <= 0 && bid2 > 0
          bid = (1/bid2).round(5)
        else
          return 0
        end
        margin = currency_count * (volume * 0.01) * bid / account.leverage
      else
        #美元在后货币对，保证金=合约量（100000）*手数*市价/杠杆
        margin = currency_count * (volume * 0.01) * open_price / account.leverage
      end
      return margin.to_f, open_price
    end


    #合约量
    def currency_quantity currency
      if currency == 'XAGUSD'
        return 1000
      elsif currency == 'XAUUSD'
        return 100
      else
        return 100000
      end
    end

    #当前买入价和卖出价
    def get_ask_and_bid symbol
      ask = $redis.lindex("#{symbol}_ASK", 0).to_f #当前卖价
      bid = $redis.lindex("#{symbol}_BID", 0).to_f #当前买价
      return ask, bid, symbol
    end

  end


  private

  def generate_identifier
    self.update_attributes(identifier: SecureRandom.uuid)
  end

  #挂单成交 params = {symbol,cmd,volume}
  def pending_trade_deal params
    self.with_lock do
      margin, open_price = Virtual::Trade.margin_use account, params
      return self.update_attributes!(open_time: Time.now, open_price: open_price, margin: margin, cmd: params[:cmd])
    end
  end

  #挂单的交易加入sidekiq任务中
  def pending_trade_jobs
    PendingTradesJob.perform_now(self.id)
  end
end
