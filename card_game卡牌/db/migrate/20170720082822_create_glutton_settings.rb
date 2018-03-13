class CreateGluttonSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :glutton_settings do |t|
      t.integer :forage_count, default: 0, comment: '饕餮吞食粮草达到的触发条件（两）'
      t.decimal :gain_user_key, precision: 3, scale: 2, default: 0, comment: '触发条件时获取每个用户的密钥数量百分比'
      t.string :show_text, default: 0, comment: '触发时显示语句'
      t.boolean :delete_flag, default: 0, comment: '删除状态，0:未删除，1:已删除'

      t.timestamps
    end
  end
end
