class AddProviderPriceToAuctionProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :provider_price, :integer, comment: '供应商结算价'
    add_column :auction_products, :provider_id, :integer, comment: '供应商ID'
    add_index :auction_products, :provider_id
  end
end
