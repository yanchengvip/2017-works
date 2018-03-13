class CreateEnergyProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :energy_products do |t|
      t.string :name, comment: '商品名称'
      t.integer :energy_count, default: 0, comment: '购买能量值'
      t.decimal :price, precision: 10, scale: 2, default: 0, comment: '购买能量值'
      t.integer :order_num, default: 0, comment: '排序'
      t.string :thumbnail, default: 0, comment: '缩略图'
      t.integer :status, default: 0, comment: '上架状态，1:已上架，0：未上架，-1:已下架'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1:已删除，0:未删除'

      t.timestamps
    end

    add_index :energy_products, :order_num

  end
end
