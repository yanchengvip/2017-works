# ## Schema Information
#
# Table name: `settings`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`var()`**       | `string(255)`      | `not null`
# **`value()`**     | `text(65535)`      |
# **`thing_id()`**  | `integer`          |
# **`thing_type()`**  | `string(30)`       |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_settings_on_thing_type_and_thing_id_and_var` (_unique_):
#     * **`thing_type`**
#     * **`thing_id`**
#     * **`var`**
#

# RailsSettings Model
class Setting < RailsSettings::Base
  source Rails.root.join("config/app.yml")
  namespace "exchange_trade_" + Rails.env
end
