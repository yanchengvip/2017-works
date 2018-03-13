class AddActivityIdToAuctionCheckLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_check_logs, :activity_id, :integer, comment: "活动id"
  end
end
