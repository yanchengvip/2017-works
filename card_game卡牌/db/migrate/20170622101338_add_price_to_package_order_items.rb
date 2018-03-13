class AddPriceToPackageOrderItems < ActiveRecord::Migration[5.0]
  def change
    add_column :package_order_items, :price, :decimal, precision: 10, scale: 2, default: 0, comment: '开出商品价值(微集分)'
  end
end
