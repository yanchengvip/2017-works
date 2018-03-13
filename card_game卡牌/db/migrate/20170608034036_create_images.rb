class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images,comment: '图片表' do |t|
      t.string :name, comment: '图片名称'
      t.string :url, comment: '图片地址'
      t.integer :table_id, comment: '所属表id'
      t.string :table_type, comment: '所属表名'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
