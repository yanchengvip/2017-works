# ## Schema Information
#
# Table name: `exchange_product_price_notices` # 价格变动消息通知表
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id()`**                 | `integer`          | `not null, primary key`
# **`user_id(用户id)`**        | `integer`          | `default(0)`
# **`exchange_product_id(外汇价格变化id)`**          | `integer`          | `default(0)`
# **`current_price(当前价格)`**  | `decimal(10, 6)`   | `default(0.0)`
# **`up_price(上涨推送价格)`**     | `decimal(10, 6)`   | `default(0.0)`
# **`down_price(下跌推送价格)`**   | `decimal(10, 6)`   | `default(0.0)`
# **`up_price_end_time(上涨推送时间)`**      | `datetime`         |
# **`down_price_end_time(下跌推送时间)`**        | `datetime`         |
# **`active(软删除标志)`**        | `boolean`          | `default(FALSE)`
# **`up_notice(上涨推送状态)`**    | `boolean`          | `default(FALSE)`
# **`down_notice(下跌推送状态)`**  | `boolean`          | `default(FALSE)`
# **`notice_type(推送方式 1 极光)`**   | `integer`          | `default(1)`
# **`dealer_id(账户类型)`**      | `integer`          | `default(0)`
# **`created_at()`**         | `datetime`         | `not null`
# **`updated_at()`**         | `datetime`         | `not null`
# **`up_price_percent(上涨价格百分比)`**      | `decimal(10, 6)`   | `default(0.0)`
# **`down_price_percent(下跌价格百分比)`**        | `decimal(10, 6)`   | `default(0.0)`
# **`ex_type(价格波动类型 1 具体价格 2 波动百分比, 范围[])`**                 | `integer`          | `default(1)`
#

class ExchangeProductPriceNotice < ApplicationRecord
  belongs_to :exchange_product
  before_create :cal_price
  validates :ex_type, inclusion: { in: [1, 2]}
  self.xml_options ={
    :only => ["id", "user_id", "exchange_product_id", "current_price", "up_price", "down_price", "up_price_end_time", "down_price_end_time", "active", "up_notice", "down_notice", "notice_type", "dealer_id", "created_at", "updated_at"].freeze,
    :include => {
      :exchange_product => { :only => ["id", "symbol"].freeze}
    }
  }

  def self.check_up_price_notice
    ExchangeProduct.active.all.each do |exchange_product|
      ExchangeProductPriceNotice.active.where("up_price < ? and up_price_end_time < '#{Time.now}' and up_notice = false and exchange_product_id = #{exchange_product.id}", exchange_product.current_price('BID')).each do |model|
        if model.ex_type == 1
          model.notice_jpush("亲，您的#{exchange_product.symbol}订单价格已高于#{exchange_product.current_price}", "亲，您的#{exchange_product.symbol}订单价格已高于#{exchange_product.current_price}！")
        else
          model.notice_jpush("亲，您的#{exchange_product.symbol}订单价格已上涨了#{model.up_price_percent.round(2) * 100}%", "亲，您的#{exchange_product.symbol}订单价格已上涨了#{model.up_price_percent.round(2) * 100}%")
        end
        model.update(up_notice: true)
      end

      ExchangeProductPriceNotice.active.where("down_price > ? and down_price_end_time < '#{Time.now}' and down_notice = false and exchange_product_id = #{exchange_product.id}", exchange_product.current_price('BID')).each do |model|
        if model.ex_type == 1
          model.notice_jpush("亲，您的#{exchange_product.symbol}订单价格已低于#{exchange_product.current_price}", "亲，您的#{exchange_product.symbol}订单价格已低于#{exchange_product.current_price}")
        else
          model.notice_jpush("亲，您的#{exchange_product.symbol}订单价格已下跌了#{exchange_product.down_price_percent * 100}%", "亲，您的#{exchange_product.symbol}订单价格已下跌了#{exchange_product.down_price_percent * 100}")
        end
        model.update(up_notice: true)
      end
    end
  end

  def notice_jpush(title, body)
    jpush = JPush::Client.new(Setting.jpush["app_key"], Setting.jpush["master_secret"])
    pusher = jpush.pusher

    alis = self.user_id
    audience = JPush::Push::Audience.new
    # audience.set_registration_id(registration_ids)
    audience.set_alias(alis)
    push_payload = JPush::Push::PushPayload.new(
      platform: 'all',
      audience: audience,
      notification: title,
      message: body,
    ).set_options({apns_production: Setting.jpush["apns_production"]})
    pusher.push(push_payload)
  end

  private
  def cal_price
    if self.ex_type == 2
      self.up_price = self.current_price  * (self.up_price_percent + 1)
      self.down_price = self.current_price  * (1 - self.up_price_percent)
    end
  end
end
