class AddPriceAndIsSellToAuctionEvents < ActiveRecord::Migration[5.1]
  def change
    begin
        add_column :auction_events, :is_sell, :boolean, comment: "是否可售", default: false
        # add_column :auction_events, :price, :decimal, :precision => 16, :scale => 2, comment: "售卖价格", default: 0
        add_column :auction_events, :micro_amount, :decimal, :precision => 16, :scale => 2, comment: "赠送微集分数量", default: 0
    rescue Exception => e
    end
  end
end
