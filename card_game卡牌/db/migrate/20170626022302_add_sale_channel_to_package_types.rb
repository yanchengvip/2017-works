class AddSaleChannelToPackageTypes < ActiveRecord::Migration[5.0]
  def change
    add_column :package_types, :sale_channel, :integer, default: 0, comment: '销售渠道 1:商城，2：战场，3:战役兑换'
  end
end
