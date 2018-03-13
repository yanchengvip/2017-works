class CreateAuctionApplyLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_apply_logs do |t|
      t.integer :apply_id, comment: "提报id"
      t.integer :user_id, comment: "审核人id"
      t.boolean :active, comment: "删除"
      t.string :content, comment: "审核备注"
      t.string :check_result, comment: "审核结果"
      t.datetime :check_time, comment: "审核时间"

      t.timestamps
    end
  end
end
