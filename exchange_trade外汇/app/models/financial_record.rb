# ## Schema Information
#
# Table name: `financial_records` # 出入金记录表
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`id()`**         | `integer`          | `not null, primary key`
# **`account_id(账户id)`**     | `integer`          |
# **`dealer_id(券商id)`**    | `integer`          |
# **`amount(存/取金额)`**  | `decimal(16, 6)`   |
# **`balance(账户余额)`**  | `decimal(16, 6)`   |
# **`dealer_type(关联券商类型1：模拟盘；2：wisdom)`**                      | `string(255)`      |
# **`active(软删除标志)`**  | `boolean`          |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`status(交易状态 0-申请成功 1-申请失败 2-入/出 金完成)`**                         | `integer`          |
# **`fr_type()`**    | `integer`          | `default(0)`
#
# ### Indexes
#
# * `fr_account_dealer_index`:
#     * **`account_id`**
#     * **`dealer_id`**
#

class FinancialRecord < ApplicationRecord
  belongs_to :account
end
