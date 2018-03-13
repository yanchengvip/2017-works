class AddPriceToPackageItems < ActiveRecord::Migration[5.0]
  def change
    add_column :package_items, :price, :decimal, precision: 10, scale: 2, comment: '选中的计谋价格'
  end
end
