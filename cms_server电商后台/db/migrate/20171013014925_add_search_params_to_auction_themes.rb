class AddSearchParamsToAuctionThemes < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_themes, :search_params, :text, comment: "专题搜索字符串"
  end
end
