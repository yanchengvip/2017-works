class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images, comment: '图片表' do |t|
      t.string :name, comment: '图片名称'
      t.string :url, comment: '图片地址'
      t.integer :table_id, comment: '所属表id'
      t.string :table_type, comment: '所属表名'
      t.text :remark, comment: '备注'
      t.boolean :active, comment: '软删除标志', default: true

      t.timestamps
    end

    add_index :images, [:table_id, :table_type], name: 'image_id_type_index'
  end
end
