class CreateGiftItems < ActiveRecord::Migration[5.0]
  def change
    create_table :gift_items do |t|
      t.integer :gift_id, comment: '礼物id'
      t.integer :gift_type, default: 0, comment: '赠品类型 1:计谋，2:入场券'
      t.integer :gift_range, comment: '礼物内容 卡牌id，0表示赠送入场券'
      t.integer :count, default: 0, comment: '礼物份数'
      t.boolean :delete_flag, default: false, comment: '删除标志 0:未删除 1:已删除，默认0'

      t.timestamps
    end
  end
end
