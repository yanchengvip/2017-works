class AddRemarkToSignGiftSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :sign_gift_settings, :remark, :text, comment: '文案'
  end
end
