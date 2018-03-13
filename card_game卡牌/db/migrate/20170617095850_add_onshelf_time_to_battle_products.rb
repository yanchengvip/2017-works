class AddOnshelfTimeToBattleProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :battle_products,:on_shelf_time,:datetime,comment: '上架时间'
    add_column :battle_products,:down_shelf_time,:datetime,comment: '下架时间'
    add_column :battle_products_copies,:on_shelf_time,:datetime,comment: '上架时间'
    add_column :battle_products_copies,:down_shelf_time,:datetime,comment: '下架时间'
  end
end
