# ## Schema Information
#
# Table name: `mt4_trades`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`TICKET()`**          | `integer`          | `not null, primary key`
# **`LOGIN()`**           | `integer`          | `not null`
# **`SYMBOL()`**          | `string(16)`       | `not null`
# **`DIGITS()`**          | `integer`          | `not null`
# **`CMD()`**             | `integer`          | `not null`
# **`VOLUME()`**          | `integer`          | `not null`
# **`OPEN_TIME()`**       | `datetime`         | `not null`
# **`OPEN_PRICE()`**      | `float(53)`        | `not null`
# **`SL()`**              | `float(53)`        | `not null`
# **`TP()`**              | `float(53)`        | `not null`
# **`CLOSE_TIME()`**      | `datetime`         | `not null`
# **`EXPIRATION()`**      | `datetime`         | `not null`
# **`REASON()`**          | `integer`          | `default(0), not null`
# **`CONV_RATE1()`**      | `float(53)`        | `not null`
# **`CONV_RATE2()`**      | `float(53)`        | `not null`
# **`COMMISSION()`**      | `float(53)`        | `not null`
# **`COMMISSION_AGENT()`**  | `float(53)`        | `not null`
# **`SWAPS()`**           | `float(53)`        | `not null`
# **`CLOSE_PRICE()`**     | `float(53)`        | `not null`
# **`PROFIT()`**          | `float(53)`        | `not null`
# **`TAXES()`**           | `float(53)`        | `not null`
# **`COMMENT()`**         | `string(32)`       | `not null`
# **`INTERNAL_ID()`**     | `integer`          | `not null`
# **`MARGIN_RATE()`**     | `float(53)`        | `not null`
# **`TIMESTAMP()`**       | `integer`          | `not null`
# **`MAGIC()`**           | `integer`          | `default(0), not null`
# **`GW_VOLUME()`**       | `integer`          | `default(0), not null`
# **`GW_OPEN_PRICE()`**   | `integer`          | `default(0), not null`
# **`GW_CLOSE_PRICE()`**  | `integer`          | `default(0), not null`
# **`MODIFY_TIME()`**     | `datetime`         | `not null`
#
# ### Indexes
#
# * `INDEX_CLOSETIME`:
#     * **`CLOSE_TIME`**
# * `INDEX_CMD`:
#     * **`CMD`**
# * `INDEX_LOGIN`:
#     * **`LOGIN`**
# * `INDEX_OPENTIME`:
#     * **`OPEN_TIME`**
# * `INDEX_STAMP`:
#     * **`TIMESTAMP`**
#

class Api::WisdomMt4Trade < Api::WisdomConnection
  self.table_name= :mt4_trades

  #  同步wisdom 订单数据
  #
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.sync_mt4_trade
    dealer_id = Dealer.active.where(dealer_type: 2).first&.id
    Api::WisdomMt4Trade.where("MODIFY_TIME > '#{Time.now -  5 * 60}' ").each do |mt4_trade|
      account_id = Account.active.where(mt4_account: mt4_trade.LOGIN).first&.id
      trade_params = {account_id: account_id, mt4_account: mt4_trade.LOGIN, order_code: mt4_trade.TICKET, symbol: mt4_trade.SYMBOL, digits: mt4_trade.DIGITS, cmd: mt4_trade.CMD, volume: mt4_trade.VOLUME, open_time: mt4_trade.OPEN_TIME, open_price: mt4_trade.OPEN_PRICE, sl: mt4_trade.SL, tp: mt4_trade.TP, close_time: mt4_trade.CLOSE_TIME, close_price: mt4_trade.CLOSE_PRICE, commission: mt4_trade.COMMISSION, profit: mt4_trade.PROFIT, source: 2, dealer_id: dealer_id, dealer_type: 2, tactic_flag: nil, trade_id: nil, request_ip: '127.0.0.1', active: true}
      if trade = Trade.active.where(order_code: mt4_trade.TICKET).first
        trade.update(trade_params)
      else
        Trade.create(trade_params)
      end
    end
  end
end
