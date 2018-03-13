# ## Schema Information
#
# Table name: `accounts` # 账号表
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id()`**                      | `integer`          | `not null, primary key`
# **`user_id(users表ID)`**         | `integer`          | `default(0)`
# **`dealer_id(券商表dealers表ID)`**  | `integer`          | `default(0)`
# **`dealer_type(关联券商类型dealer_type)`**      | `integer`          | `default(0)`
# **`status(账号状态;1:启用,2:禁用)`**    | `integer`          | `default(1)`
# **`agent_account(代理账号)`**       | `string(255)`      |
# **`mt4_account(MT4账号)`**        | `string(255)`      |
# **`mt4_group(MT4组)`**           | `string(255)`      |
# **`name(姓名)`**                  | `string(255)`      |
# **`email(邮箱)`**                 | `string(255)`      |
# **`phone(手机号)`**                | `string(255)`      |
# **`certificate(证件类型)`**         | `string(255)`      |
# **`certificate_num(证件号)`**      | `string(255)`      |
# **`img_url(证件图片地址)`**           | `string(255)`      |
# **`country(国家)`**               | `string(255)`      |
# **`city(城市)`**                  | `string(255)`      |
# **`state(状态)`**                 | `string(255)`      |
# **`leverage(交易杠杆)`**            | `integer`          | `default(1)`
# **`balance(余额)`**               | `decimal(16, 6)`   |
# **`equity(净值)`**                | `decimal(16, 6)`   |
# **`margin(已用保证金)`**             | `decimal(16, 6)`   |
# **`margin_free(可用保证金)`**        | `decimal(16, 6)`   |
# **`credit(信用)`**                | `decimal(16, 6)`   |
# **`is_master(是否大师)`**           | `boolean`          | `default(FALSE)`
# **`currency(货币代码)`**            | `string(255)`      |
# **`request_ip(登录ip地址)`**        | `string(255)`      |
# **`active(软删)`**                | `boolean`          | `default(TRUE)`
# **`created_at()`**              | `datetime`         | `not null`
# **`updated_at()`**              | `datetime`         | `not null`
# **`followers_count(关注者人数)`**    | `integer`          | `default(0)`
# **`pwd(mt4交易密码)`**              | `string(255)`      |
# **`redpwd(mt4只读密码)`**           | `string(255)`      |
# **`profit(收益、盈亏)`**             | `decimal(16, 6)`   | `default(0.0)`
# **`yield_rate(收益率)`**           | `decimal(16, 6)`   | `default(0.0)`
# **`winrate(胜率)`**               | `decimal(16, 6)`   | `default(0.0)`
# **`sl(最大亏损)`**                  | `decimal(16, 6)`   | `default(0.0)`
# **`tp(最大盈利)`**                  | `decimal(16, 6)`   | `default(0.0)`
# **`total_follow_trade_num(跟随人数)`**    | `integer`          | `default(0)`
# **`total_follow_trade_price(跟随金额)`**      | `decimal(16, 6)`   | `default(0.0)`
#
# ### Indexes
#
# * `index_accounts_on_mt4_account` (_unique_):
#     * **`mt4_account`**
# * `index_accounts_on_phone`:
#     * **`phone`**
# * `user_dealer_index` (_unique_):
#     * **`user_id`**
#     * **`dealer_id`**
#

class Account < ApplicationRecord
  action_store :follow, :account, counter_cache: 'followers_count', account_counter_cache: 'following_count'
  belongs_to :user
  belongs_to :dealer
  has_many :booking_trades
  has_many :trades
  has_many :account_medals
  has_many :medals,through: :account_medals
  has_many :financial_records
  has_many :account_logs
  has_many :account_masters
  has_many :master_accounts,class_name: 'AccountMaster',foreign_key: :master_id
  has_many :accounts,through: :master_accounts

  self.xml_options = {
    :only => ["id", "user_id", "dealer_id", "dealer_type", "status", "agent_account", "mt4_account", "mt4_group", "name", "email", "phone", "certificate", "certificate_num", "img_url", "country", "city", "state", "leverage", "balance", "equity", "margin", "margin_free", "credit", "is_master", "currency", "followers_count"].freeze,
    :include => {
      :user => { :only => ["id", "nickname", "headimgurl", ]}
    }
  }


  def self.cal_logs day=nil
    day ||= Date.today
    Account.find_each do |account|
      account.cal_logs(day)
    end
  end

  def cal_logs day
    begin
      data = {
        day: day,
        profit: self.cal_day_profit(day),
        equity: self.equity,
        balance: self.balance,
        margin: self.margin,
        margin_free: self.margin_free,
      }
      self.account_logs.create(data)
    rescue Exception => e
      Rails.logger.info(e)
    end
  end

  #计算当天盈亏
  def cal_day_profit day
    profit = self.trades.where("close_time >= '#{day.beginning_of_day}' and close_time < '#{(day+1).beginning_of_day}'").sum(:profit)
  end
end
