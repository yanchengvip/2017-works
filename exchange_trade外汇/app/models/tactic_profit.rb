# ## Schema Information
#
# Table name: `tactic_profits` # 策略跟随者收益明细
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`account_id(账户ID)`**     | `integer`          | `default(0)`
# **`tactic_id(策略ID)`**    | `integer`          | `default(0)`
# **`tactic_flag(策略唯一标识符)`**         | `string(255)`      | `default("0")`
# **`amount(收益;+-)`**  | `decimal(16, 6)`   | `default(0.0)`
# **`date(日期)`**     | `datetime`         |
# **`dealer_type(关联券商类型1：模拟盘；2：wisdom)`**                      | `integer`          | `default(0)`
# **`dealer_id(关联券商id)`**      | `integer`          |
# **`active(软删除标志)`**  | `boolean`          |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `atd_index`:
#     * **`account_id`**
#     * **`tactic_id`**
#     * **`dealer_id`**
# * `tp_atd_index`:
#     * **`account_id`**
#     * **`tactic_flag`**
#     * **`dealer_id`**
#

class TacticProfit < ApplicationRecord
end
