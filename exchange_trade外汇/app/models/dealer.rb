# ## Schema Information
#
# Table name: `dealers` # 券商表
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`name(交易商名称)`**  | `string(255)`      |
# **`dealer_type(券商类型;0:无,1:模拟盘账户,2:wisdom账户)`**                             | `integer`          | `default(0)`
# **`status(1:启用,2：禁用)`**      | `integer`          | `default(1)`
# **`content(描述)`**  | `string(255)`      |
# **`request_ip(登录ip地址)`**       | `string(255)`      |
# **`active(软删)`**   | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`svr_id(流水号 新增-系统自动生成 删除-必须传入原ID  更新-必须传入原ID)`**                                 | `string(255)`      |
# **`svr_name( 服务器名称)`**     | `string(255)`      |
# **`ip(ip)`**       | `string(255)`      |
# **`port(端口)`**     | `string(255)`      |
# **`desc(说明)`**     | `string(255)`      |
#
# ### Indexes
#
# * `index_dealers_on_dealer_type`:
#     * **`dealer_type`**
# * `index_dealers_on_name`:
#     * **`name`**
#

class Dealer < ApplicationRecord
  has_many :accounts
end
