class AddIsMicroAndMicroAmountAndIsHotToAuctionProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :is_micro, :boolean, default: false, comment: "微积分特惠商品"
    add_column :auction_products, :is_hot, :boolean, default: false, comment: "热门商品"
    add_column :auction_products, :micro_amount, :decimal, :precision => 16, :scale => 2, default: -1, comment: "赠送微积分, -1 为赠送 5%，大于0 其他值为实际赠送微积分数"
  end
end
