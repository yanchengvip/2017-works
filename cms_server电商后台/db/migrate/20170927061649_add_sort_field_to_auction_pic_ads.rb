class AddSortFieldToAuctionPicAds < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_pic_ads, :sort_field, :integer, default: 0, comment:"排序字段 数值大的排序前面"
  end
end
