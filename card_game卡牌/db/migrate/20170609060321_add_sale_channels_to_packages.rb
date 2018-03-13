class AddSaleChannelsToPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :packages, :sale_channels, :string, comment: '销售渠道 1：卡牌商城，2：战场，1,2：全可售卖'
  end
end
