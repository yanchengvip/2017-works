# ## Schema Information
#
# Table name: `account_logs` # 账户每日盈亏 净值记录表
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`day(记录日期)`**    | `string(255)`      |
# **`account_id(账户id)`**     | `integer`          |
# **`profit(盈亏)`**   | `decimal(16, 6)`   |
# **`equity(净值)`**   | `decimal(16, 6)`   |
# **`balance(余额)`**  | `decimal(16, 6)`   |
# **`margin(保证金)`**  | `decimal(16, 6)`   |
# **`margin_free(可用保证金)`**       | `decimal(16, 6)`   |
# **`active(软删除字段)`**  | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_account_logs_on_account_id`:
#     * **`account_id`**
# * `index_account_logs_on_day_and_account_id_and_active` (_unique_):
#     * **`day`**
#     * **`account_id`**
#     * **`active`**
#

class AccountLog < ApplicationRecord
end
