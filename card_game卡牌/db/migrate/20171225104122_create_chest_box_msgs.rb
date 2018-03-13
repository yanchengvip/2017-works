class CreateChestBoxMsgs < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_box_msgs, comment: '开启宝箱提示信息' do |t|
      t.text :content, comment: '信息内容'
      t.integer :msg_type, default: 0, comment: '提示类别1=开启免费宝箱，次数不足，但拥有宝箱券可开启任意一个宝箱,2=开启当前付费宝箱（宝箱符开启），宝箱符数量不足，但拥有宝箱券可开启其他付费宝箱,3=开启付费宝箱后，剩余宝箱符无法开启任何付费宝箱，且拥有免费开启次数,4=用户开启完宝箱后，所有免费次数、宝箱符数量均不足开启任何一个宝箱,5=当用户进入宝箱界面，免费次数＆宝箱符均不够开启任何1个宝箱'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
