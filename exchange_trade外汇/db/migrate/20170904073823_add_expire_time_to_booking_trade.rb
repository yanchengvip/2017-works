class AddExpireTimeToBookingTrade < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_trades, :expire_time, :datetime, comment: '挂单有效期'
  end
end
