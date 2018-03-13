class AddRankToAuctionCarousels < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_carousels, :rank, :integer, default: 0, comment:"排序字段 数值大的排序前面"
  end
end
