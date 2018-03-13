# ## Schema Information
#
# Table name: `exchange_products` # 外汇品种
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id()`**        | `integer`          | `not null, primary key`
# **`symbol(外汇品种标志)`**    | `string(255)`      |
# **`active(软删除标志)`**   | `boolean`          |
# **`published(是否发布)`**     | `boolean`          |
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
#

class ExchangeProduct < ApplicationRecord

  def current_price(type = 'BID')
    if type == 'BID'
      if self.dealer_type == 1 || self.dealer_type == 2
        Api::WisdomMt4Price.where(symbol: self.symbol).first&.BID
      end
    else
      if self.dealer_type == 1 || self.dealer_type == 2
        Api::WisdomMt4Price.where(symbol: self.symbol).first&.ASK
      end
    end
  end
end
