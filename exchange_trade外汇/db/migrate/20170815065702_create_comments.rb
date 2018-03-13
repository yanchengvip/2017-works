class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments, comment: '评论表' do |t|
      t.integer :user_id, comment: '用户id'
      t.text :content, comment: '内容'
      t.integer :status, comment: '1:审核中,2:审核通过3：审核失败', default: 1
      t.string :request_ip, comment: '发布ip'
      t.integer :table_id, comment: '关联表id'
      t.string :table_name, comment: '关联表 表明'
      t.boolean :active, comment: '软删除标志', default: true

      t.timestamps
    end

    add_index :comments, :user_id
  end
end
