class ChangeDiscountForAuctionSeckills < ActiveRecord::Migration[5.1]
  def change
    change_column :auction_seckills, :discount, :integer
  end
end
