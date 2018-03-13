# ## Schema Information
#
# Table name: `medals` # 勋章表
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`name(勋章名称)`**  | `string(255)`      |
# **`condition(完成条件)`**     | `float(24)`        |
# **`medal_type(类型;1:交易次数;2:盈利次数;3:复制交易次数；4:入金次数5:账户余额；6:跟随者；7:邀请好友8:交易资金)`**                                                           | `integer`          |
# **`image(勋章图片)`**  | `string(255)`      |
# **`content(勋章简介)`**   | `text(65535)`      |
# **`enable(0:禁用2：启用)`**      | `integer`          |
# **`active(软删除字段)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`level(功勋级别)`**  | `integer`          |
#
# ### Indexes
#
# * `index_medals_on_name`:
#     * **`name`**
#

require 'test_helper'

class MedalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
