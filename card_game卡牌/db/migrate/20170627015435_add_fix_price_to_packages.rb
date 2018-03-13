class AddFixPriceToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :fix_price, :decimal, precision: 10, scale: 2, default: 0, comment: '等值随机礼包的价值'
    add_column :package_items, :range_count, :string, comment: '等值随机礼包方案里的每个卡牌数量，如1,2,3'
  end
end
