class AddProviderIdToAuctionSkus < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_skus, :provider_id, :integer, comment: "供应商ID", default: 0
  end
end
