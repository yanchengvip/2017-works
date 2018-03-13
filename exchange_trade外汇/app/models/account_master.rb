# ## Schema Information
#
# Table name: `account_masters` # 账户大师关联表
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id()`**          | `integer`          | `not null, primary key`
# **`account_id(账户表ID)`**     | `integer`          | `default(0)`
# **`master_id(大师账户表ID)`**      | `integer`          | `default(0)`
# **`dealer_id(券商表dealers表ID)`**            | `integer`          | `default(0)`
# **`dealer_type(关联券商类型dealer_type)`**                  | `integer`          | `default(0)`
# **`request_ip(登录ip地址)`**      | `string(255)`      |
# **`active(软删)`**    | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`follow_money(跟随金额)`**      | `decimal(16, 6)`   |
#
# ### Indexes
#
# * `account_master_dealer_index`:
#     * **`account_id`**
#     * **`master_id`**
#     * **`dealer_id`**
#

class AccountMaster < ApplicationRecord
  belongs_to :account, optional: true, foreign_key: "account_id", class_name: "Account"
  belongs_to :master,foreign_key: 'master_id', class_name: 'Account'
  self.xml_options = {
    :only => ["id", "account_id", "master_id","dealer_id", "dealer_type", "follow_money", "created_at"].freeze,
    :include => {
      :account => { :only => ["name", "img_url", "yield_rate" ].freeze}
    }
  }
end
