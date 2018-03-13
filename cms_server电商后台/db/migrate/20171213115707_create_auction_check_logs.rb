class CreateAuctionCheckLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_check_logs do |t|
      t.integer :pass_user_id, comment: "通过审核的人"
      t.integer :unpass_user_id, comment: "驳回审核的人"
      t.string :content, comment: "审核备注", default: ""
      t.timestamps
    end
  end
end
