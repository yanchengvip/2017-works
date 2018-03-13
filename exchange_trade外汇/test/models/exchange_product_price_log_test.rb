# ## Schema Information
#
# Table name: `exchange_product_price_logs` # 外汇品种价格日志
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id()`**                 | `integer`          | `not null, primary key`
# **`exchange_product_id(外汇品种id)`**        | `integer`          |
# **`dealer_id(券商id)`**      | `integer`          |
# **`dealer_type(券商类型)`**    | `string(255)`      |
# **`price(当前价格)`**          | `decimal(16, 6)`   |
# **`time(时间戳)`**            | `datetime`         |
# **`active(软删除标志)`**        | `boolean`          |
# **`created_at()`**         | `datetime`         | `not null`
# **`updated_at()`**         | `datetime`         | `not null`
#

require 'test_helper'

class ExchangeProductPriceLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
