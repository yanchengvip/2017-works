class RemoveTypeToExchangeProductPriceNotices < ActiveRecord::Migration[5.1]
  def change
    remove_column :exchange_product_price_notices, :type, :integer
    add_column :exchange_product_price_notices, :ex_type, :integer, default: 1, comment: '价格波动类型 1 具体价格 2 波动百分比, 范围[]'

  end
end
