class AddProductsToAuctionThemes < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_themes, :products, :text, comment: "专题相关商品信息"
  end
end
