class Detection < ActiveRecord::Migration[5.1]
  def change
    create_table :detections, comment: '发现表' do |t|
      t.integer :table_id, comment: '关联表id'
      t.string :table_name, comment: '关联表名'
      t.text :remark, comment: '备注'
      t.boolean :active, comment: '软删除标志', default: true

      t.timestamps
    end
    add_index :detections, [:table_id, :table_name], name: 'detection_id_name_index'
  end
end
