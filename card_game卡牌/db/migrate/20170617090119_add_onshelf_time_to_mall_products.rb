class AddOnshelfTimeToMallProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :mall_products,:on_shelf_time,:datetime,comment: '上架时间'
    add_column :mall_products,:down_shelf_time,:datetime,comment: '下架时间'
  end
end
