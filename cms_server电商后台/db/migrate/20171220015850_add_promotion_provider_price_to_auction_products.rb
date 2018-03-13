class AddPromotionProviderPriceToAuctionProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :promotion_provider_price, :decimal, precision: 16, scale: 2, comment: "活动结算价"
  end
end
