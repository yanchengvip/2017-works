# ## Schema Information
#
# Table name: `mt4_prices`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`SYMBOL()`**     | `string(16)`       | `not null, primary key`
# **`TIME()`**       | `datetime`         | `not null`
# **`BID()`**        | `float(53)`        | `not null`
# **`ASK()`**        | `float(53)`        | `not null`
# **`LOW()`**        | `float(53)`        | `not null`
# **`HIGH()`**       | `float(53)`        | `not null`
# **`DIRECTION()`**  | `integer`          | `not null`
# **`DIGITS()`**     | `integer`          | `not null`
# **`SPREAD()`**     | `integer`          | `not null`
# **`MODIFY_TIME()`**  | `datetime`         | `not null`
#

class Api::WisdomMt4Price < Api::WisdomConnection
  self.table_name= :mt4_prices

  #  同步wisdom 外汇品种数据
  #
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.sync_wisdom_product
    # ExchangeProduct(id: integer, symbol: string, active: boolean, published: boolean, created_at: datetime, updated_at: datetime)
    #<Api::WisdomMt4Price SYMBOL: "XTIUSD.lmx", TIME: "2017-08-21 22:51:42", BID: 47.731, ASK: 47.759, LOW: 47.581, HIGH: 47.773, DIRECTION: 0, DIGITS: 3, SPREAD: 0, MODIFY_TIME: "2017-08-22 03:51:44">
    Api::WisdomMt4Price.all.each do |wisdom_price|
      if ExchangeProduct.active.where(symbol: wisdom_price.SYMBOL).blank?
        ExchangeProduct.create(symbol: wisdom_price.SYMBOL, active: true, published: true)
      end
    end
  end
end
