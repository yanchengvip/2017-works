class AddIsMainToSignGiftSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :sign_gift_settings, :is_main, :boolean, default: false, comment: '是否突出显示'
  end
end
