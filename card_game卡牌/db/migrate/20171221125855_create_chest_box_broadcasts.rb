class CreateChestBoxBroadcasts < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_broadcasts, comment: '宝箱广播（顶部广播）' do |t|
      t.string :content, default: '', comment: '广播内容'
      t.integer :admin_id, default: 0, comment: '创建人id'
      t.boolean :published, default: true, comment: '是否已发布，默认 1:已发布，0:未发布'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
