class AddBeginTimeToAuctionSeckills < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_seckills, :begin_time, :string, comment: "开始时间"
    add_column :auction_seckills, :end_time, :string, comment: "结束时间"
  end
end
