class CreateActivityItems < ActiveRecord::Migration[5.0]
  def change
    drop_table :activity_cards

    create_table :activity_items do |t|
      t.integer :activity_id, default: 0, comment: '活动id'
      t.integer :gift_type, default: 0, comment: '赠品类型 1:计谋，2:入场券'
      t.string :gift_range, comment: '赠品范围，card_id或入场券'
      t.integer :gift_count, default: 0, comment: '赠品份数'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1:已删除'

      t.timestamps
    end
  end
end
