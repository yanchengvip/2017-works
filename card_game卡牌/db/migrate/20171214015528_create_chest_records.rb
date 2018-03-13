class CreateChestRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_records, comment: '抽取记录表' do |t|
      t.integer :chest_box_id, default: 0, comment: '宝箱id'
      t.string :user_id, default: 0, comment: '用户id'
      t.string :chest_prize_ids, default: '', comment: '抽到到商品id，英文逗号隔开，如：1,2,3'
      t.boolean :is_shared, default: false, comment: '是否已分享，默认0:未分享:已分享'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'
      t.timestamps
    end

    add_index :chest_records, [:chest_box_id, :user_id]
  end
end
