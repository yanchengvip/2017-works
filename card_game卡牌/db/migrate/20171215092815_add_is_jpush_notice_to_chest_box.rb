class AddIsJpushNoticeToChestBox < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :is_jpush_notcie, :boolean, default: false, comment: "是否推送极光消息"
  end
end
