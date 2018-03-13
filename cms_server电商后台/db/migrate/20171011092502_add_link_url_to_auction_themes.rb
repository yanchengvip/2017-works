class AddLinkUrlToAuctionThemes < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_themes, :link_url, :text, comment: "外链url"
  end
end
