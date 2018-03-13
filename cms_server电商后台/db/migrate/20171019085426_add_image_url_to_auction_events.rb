class AddImageUrlToAuctionEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_events, :pic, :text
  end
end
