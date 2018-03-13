# ## Schema Information
#
# Table name: `areas` # 地区表
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`area_id(上级地区id)`**     | `integer`          | `default(0)`
# **`name(名称)`**    | `string(255)`      |
# **`active(软删除标志)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#

require 'test_helper'

class AreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
