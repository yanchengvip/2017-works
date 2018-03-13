class CreateBattleProductsCopies < ActiveRecord::Migration[5.0]
  def change
    create_table :battle_products_copies,comment: '战役&商品关系表，记录商品快照' do |t|
      t.integer :battle_id, comment: '战役表ID'
      t.integer :battle_product_id, comment: '战役商品表ID'
      t.integer :status, default: 0, comment: '战役&商品关系表状态;0:启用,1:禁用'
      t.boolean :delete_flag, default: 0, comment: '删除标志，0:不删除,1 删除'
      t.text    :battle_product_copy, comment: '商品快照'
      t.string :name, comment: '商品名称'
      t.decimal :market_price, default: 0, precision: 10, scale: 2, comment: '市场价格'
      t.decimal :cost_price, default: 0, precision: 10, scale: 2, comment: '成本价格'
      t.integer :inventory_count, default: 0, comment: '库存'
      t.decimal :postage, default: 0, precision: 10, scale: 2, comment: '邮费'
      t.string :thumbnail, comment: '商品缩略图'
      t.text   :desc,comment: '商品描述'
      t.string :detail_url,comment: '商品详情地址'
      t.integer :product_tag_id,default:0,comment: '商品类别表ID'
      t.timestamps
    end
  end
end
