class CreateExtremeChests < ActiveRecord::Migration[5.0]
  def change
    create_table :extreme_chests do |t|
      t.boolean :status, default: true, comment: '前台启用 1:启用，0关闭'
      t.integer :card_count, default: 0, comment: '当日累计使用计谋满多少张赠送'
      t.datetime :refresh_time, comment: '礼包刷新时间 每天'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1:已删除'

      t.timestamps
    end
  end
end
