# ## Schema Information
#
# Table name: `exchange_products` # 外汇品种
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`symbol(外汇品种标志)`**    | `string(255)`      |
# **`active(软删除标志)`**   | `boolean`          |
# **`published(是否发布)`**     | `boolean`          |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#

require 'test_helper'

class ExchangeProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
