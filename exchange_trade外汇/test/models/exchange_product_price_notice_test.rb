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

require 'test_helper'

class ExchangeProductPriceNoticeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
