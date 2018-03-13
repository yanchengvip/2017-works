class AddOnshelfTimeToBattle < ActiveRecord::Migration[5.0]
  def change
    add_column :battles, :on_shelf_time, :datetime, comment: '上架时间'
    add_column :battles,:down_shelf_time, :datetime, comment: '下架时间'
  end
end
