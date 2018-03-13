class AddSkuNameToAuctionUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_units, :sku_name, :string,comment: '尺码：xl,xxl'
    add_column :auction_units, :provider_id, :integer,comment: '供应商ID'
  end
end
