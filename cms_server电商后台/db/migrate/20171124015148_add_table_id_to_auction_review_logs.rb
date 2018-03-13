class AddTableIdToAuctionReviewLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_review_logs, :table_id, :integer, default: 0, comment: '审核对象表id'
    add_column :auction_review_logs, :table_type, :string, default: '', comment: '审核对象资源名，如：Product'
    add_column :auction_review_logs, :remark, :string, default: '', comment: '备注'
    remove_column :auction_review_logs, :product_id
    add_index :auction_review_logs, [:table_id, :table_type], name: 'review_log_table_index'
  end
end
