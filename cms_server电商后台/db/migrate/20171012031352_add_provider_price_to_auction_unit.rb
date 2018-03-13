class AddProviderPriceToAuctionUnit < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_units, :provider_price, :decimal, precision: 16, scale: 2, comment: "供应商结算价"
  end
end
