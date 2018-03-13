class AddUseVoucherToAuctionProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_products, :use_voucher, :boolean, default: false, comment: "是否禁止用券 默认：0不禁止"
  end
end
