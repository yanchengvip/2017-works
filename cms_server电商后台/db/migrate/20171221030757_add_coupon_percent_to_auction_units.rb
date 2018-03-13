class AddCouponPercentToAuctionUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_units, :coupon_percent, :decimal, precision: 12, scale: 2, default: 0, comment: '券优惠折扣'
    add_column :auction_units, :multi_percent, :decimal, precision: 12, scale: 2, default: 0, comment: '连拍折扣'
    add_column :auction_units, :every_full_percent, :decimal, precision: 12, scale: 2, default: 0, comment: '每满减折扣'
    add_column :auction_units, :full_percent, :decimal, precision: 12, scale: 2, default: 0, comment: '满减折扣'
    add_column :auction_units, :pay_percent, :decimal, precision: 12, scale: 2, default: 0, comment: '支付优惠折扣（微信或者支付宝等）'
    add_column :auction_units, :postage, :decimal, precision: 12, scale: 2, default: 0, comment: '邮费'
  end
end
