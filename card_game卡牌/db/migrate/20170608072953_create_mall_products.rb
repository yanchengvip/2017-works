class CreateMallProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :mall_products, comment: '通兑商城商品表' do |t|
      t.string :name, comment: '商品名称'
      t.integer :status, default: 0, comment: '0:下架,1:上架'
      t.decimal :market_price, default: 0, precision: 10, scale: 2, comment: '市场价格'
      t.decimal :cost_price, default: 0, precision: 10, scale: 2, comment: '成本价格'
      t.integer :inventory_count, default: 0, comment: '库存'
      t.integer :product_tag_id, default: 0, comment: '商品类别表ID'
      t.integer :exchange_type, default: 0, comment: '通兑方式;0:微集券,1:微集分,2:微集券或微集分'
      t.integer :micro_ticket, default: 0, comment: '微集券，通兑方式'
      t.integer :micro_score, default: 0, comment: '微集分，通兑方式'
      t.decimal :postage, default: 0, precision: 10, scale: 2, comment: '邮费'
      t.string :thumbnail, comment: '商品缩略图'
      t.text :desc, comment: '商品描述'
      t.string :detail_url, comment: '商品详情地址,优众网链接'
      t.integer :sort, default: 0, comment: '排序，desc排序'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.timestamps
    end
  end
end
