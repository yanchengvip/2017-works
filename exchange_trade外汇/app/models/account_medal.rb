# ## Schema Information
#
# Table name: `account_medals` # 账户功勋表
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id()`**          | `integer`          | `not null, primary key`
# **`account_id(账户ID)`**    | `integer`          | `default(0)`
# **`medal_id(功勋ID)`**  | `integer`          | `default(0)`
# **`medal_type(功勋类型)`**    | `integer`          | `default(0)`
# **`active(软删除标志)`**  | `boolean`          | `default(TRUE)`
# **`achieve_time(获取功勋时间)`**        | `datetime`         |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `account_medal_index`:
#     * **`account_id`**
#     * **`medal_id`**
#

class AccountMedal < ApplicationRecord
  belongs_to :medal
  self.xml_options = {
    :only => ["id", "account_id", "medal_id", "medal_type", "achieve_time",  "created_at"] .freeze,
    :include => {
      :medal => { :only => ["name", "condition", "medal_type", "image", "content", "level" ]}
    }
  }
end
