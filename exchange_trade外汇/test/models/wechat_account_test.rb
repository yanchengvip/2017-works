# ## Schema Information
#
# Table name: `wechat_accounts` # 微信用户
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`user_id(user表ID)`**      | `integer`          | `default(0)`
# **`openid()`**    | `string(255)`      |
# **`nickname(微信昵称)`**    | `string(255)`      |
# **`sex(性别；0:未知,1:男,2:女)`**          | `integer`          | `default(0)`
# **`province(省)`**  | `string(255)`      |
# **`city(市)`**     | `string(255)`      |
# **`country(国家)`**  | `string(255)`      |
# **`headimgurl(头像)`**    | `string(255)`      |
# **`request_ip(登录ip地址)`**        | `string(255)`      |
# **`active(软删)`**  | `boolean`          | `default(TRUE)`
# **`unionid(只有在用户将公众号绑定到微信开放平台帐号后，才会出现该字段)`**                            | `string(255)`      |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_wechat_accounts_on_openid` (_unique_):
#     * **`openid`**
# * `index_wechat_accounts_on_user_id` (_unique_):
#     * **`user_id`**
#

require 'test_helper'

class WechatAccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
