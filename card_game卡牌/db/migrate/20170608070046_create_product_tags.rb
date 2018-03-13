class CreateProductTags < ActiveRecord::Migration[5.0]
  def change
    create_table :product_tags, comment: '商品类别表' do |t|
      t.string :name, comment: '商品类别名称'
      t.integer :sort, comment: '商品类别排序，根据desc排序'
      t.integer :status, default: 0, comment: '状态,0:正常，1：禁用'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
