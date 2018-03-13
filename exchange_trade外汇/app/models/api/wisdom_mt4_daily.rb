# ## Schema Information
#
# Table name: `mt4_daily`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`LOGIN()`**        | `integer`          | `not null`
# **`TIME()`**         | `datetime`         | `not null`
# **`GROUP()`**        | `string(16)`       | `not null`
# **`BANK()`**         | `string(64)`       | `not null`
# **`BALANCE_PREV()`**  | `float(53)`        | `not null`
# **`BALANCE()`**      | `float(53)`        | `not null`
# **`DEPOSIT()`**      | `float(53)`        | `not null`
# **`CREDIT()`**       | `float(53)`        | `not null`
# **`PROFIT_CLOSED()`**  | `float(53)`        | `not null`
# **`PROFIT()`**       | `float(53)`        | `not null`
# **`EQUITY()`**       | `float(53)`        | `not null`
# **`MARGIN()`**       | `float(53)`        | `not null`
# **`MARGIN_FREE()`**  | `float(53)`        | `not null`
# **`MODIFY_TIME()`**  | `datetime`         | `not null`
#

require 'composite_primary_keys'
class Api::WisdomMt4Daily < Api::WisdomConnection
  self.table_name= :mt4_daily
  self.primary_key= :login, :time
end
