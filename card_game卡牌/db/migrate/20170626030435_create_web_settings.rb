class CreateWebSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :web_settings do |t|
      t.integer :link_expire_hours, default: 0, comment: '好友赠送链接失效时间，小时（整数）'

      t.timestamps
    end
  end
end
