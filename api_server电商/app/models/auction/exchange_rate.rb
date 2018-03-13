class Auction::ExchangeRate < ApplicationRecord
  #汇率换算
  #当前币种或者 目标币种至少一个是CNY 或者 两者相同
  #
  def self.exchange( price, to, from = nil)
    from ||= Setting.pay["currency"]
    if from == to
      return price

    elsif to == 'CNY'
      tag = 1
      change = get_exchange_rate_price(from, to)
      return (price.to_f * change).round(2)
    elsif from == 'CNY'
      tag = 2
      change = get_exchange_rate_price(to, from)
      return (price.to_f / change).round(2)
    else
      return false
    end

  end

  def self.get_exchange_rate_price(from, to, day = Date.today.to_s)
    exchange_rate = self.where(day: day, from: from, to: to).last
    exchange_rate = self.where(day: day, from: from, to: to).order(" day desc, created_at desc").first unless exchange_rate
    exchange_rate&.price.to_f
  end

end
