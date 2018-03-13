class AddSaleChannelToPackageOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :package_orders, :sale_channel, :integer, default: 0, comment: '销售渠道 1：卡牌商城，2：战场'
  end
end
