# ## Schema Information
#
# Table name: `mt4_users`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`LOGIN()`**             | `integer`          | `not null, primary key`
# **`GROUP()`**             | `string(16)`       | `not null`
# **`ENABLE()`**            | `integer`          | `not null`
# **`ENABLE_CHANGE_PASS()`**  | `integer`          | `not null`
# **`ENABLE_READONLY()`**   | `integer`          | `not null`
# **`ENABLE_OTP()`**        | `integer`          | `default(0), not null`
# **`PASSWORD_PHONE()`**    | `string(32)`       | `not null`
# **`NAME()`**              | `string(128)`      | `not null`
# **`COUNTRY()`**           | `string(32)`       | `not null`
# **`CITY()`**              | `string(32)`       | `not null`
# **`STATE()`**             | `string(32)`       | `not null`
# **`ZIPCODE()`**           | `string(16)`       | `not null`
# **`ADDRESS()`**           | `string(128)`      | `not null`
# **`LEAD_SOURCE()`**       | `string(32)`       | `default(""), not null`
# **`PHONE()`**             | `string(32)`       | `not null`
# **`EMAIL()`**             | `string(48)`       | `not null`
# **`COMMENT()`**           | `string(64)`       | `not null`
# **`ID()`**                | `string(32)`       | `not null`
# **`STATUS()`**            | `string(16)`       | `not null`
# **`REGDATE()`**           | `datetime`         | `not null`
# **`LASTDATE()`**          | `datetime`         | `not null`
# **`LEVERAGE()`**          | `integer`          | `not null`
# **`AGENT_ACCOUNT()`**     | `integer`          | `not null`
# **`TIMESTAMP()`**         | `integer`          | `not null`
# **`BALANCE()`**           | `float(53)`        | `not null`
# **`PREVMONTHBALANCE()`**  | `float(53)`        | `not null`
# **`PREVBALANCE()`**       | `float(53)`        | `not null`
# **`CREDIT()`**            | `float(53)`        | `not null`
# **`INTERESTRATE()`**      | `float(53)`        | `not null`
# **`TAXES()`**             | `float(53)`        | `not null`
# **`SEND_REPORTS()`**      | `integer`          | `not null`
# **`MQID()`**              | `integer`          | `default(0), unsigned, not null`
# **`USER_COLOR()`**        | `integer`          | `not null`
# **`EQUITY()`**            | `float(53)`        | `default(0.0), not null`
# **`MARGIN()`**            | `float(53)`        | `default(0.0), not null`
# **`MARGIN_LEVEL()`**      | `float(53)`        | `default(0.0), not null`
# **`MARGIN_FREE()`**       | `float(53)`        | `default(0.0), not null`
# **`CURRENCY()`**          | `string(16)`       | `default(""), not null`
# **`API_DATA()`**          | `binary(65535)`    |
# **`MODIFY_TIME()`**       | `datetime`         | `not null`
#
# ### Indexes
#
# * `INDEX_STAMP`:
#     * **`TIMESTAMP`**
#

class Api::WisdomMt4User < Api::WisdomConnection
  self.table_name= :mt4_users

  #  同步wisdom 账户数据
  #
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.sync_wisdom_account
    dealer_id = Dealer.where(dealer_type: 2).first&.id
    Api::WisdomMt4User.all.each do | mt4_user|
      account_params = {mt4_account: mt4_user.LOGIN,
         dealer_id: dealer_id, dealer_type: 2, agent_account: mt4_user.AGENT_ACCOUNT,   mt4_group: mt4_user.GROUP, name: mt4_user.NAME, email: mt4_user.EMAIL, phone: mt4_user.PHONE, certificate: nil, certificate_num: nil, img_url: nil, country: mt4_user.COUNTRY, city: mt4_user.CITY, state: mt4_user.STATE, leverage: mt4_user.LEVERAGE, balance: mt4_user.BALANCE, equity: mt4_user.EQUITY, margin: mt4_user.MARGIN, margin_free: mt4_user.MARGIN_FREE, credit: mt4_user.CREDIT, is_master: false, currency: mt4_user.CURRENCY, }
      if account = Account.active.where(mt4_account: mt4_user.LOGIN).first
        account.update(account_params)
      else
        user = User.create(nickname: mt4_user.NAME, email: mt4_user.EMAIL, sex: 0, desc: "wisdom 账户")
        user.accounts.create(account_params)
      end
    end
  end
end
