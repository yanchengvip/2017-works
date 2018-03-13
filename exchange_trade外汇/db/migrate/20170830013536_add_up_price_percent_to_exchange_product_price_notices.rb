class AddUpPricePercentToExchangeProductPriceNotices < ActiveRecord::Migration[5.1]
  def change
    add_column :exchange_product_price_notices, :up_price_percent, :decimal, precision: 10, scale: 6, comment: "上涨价格百分比", default: 0
    add_column :exchange_product_price_notices, :down_price_percent, :decimal, precision: 10, scale: 6, comment: "下跌价格百分比", default: 0
    add_column :exchange_product_price_notices, :type, :integer, comment: "价格波动类型 1 具体价格 2 波动百分比, 范围[]", default: 1
  end
end
