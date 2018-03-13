class AddItemTypeToPackageItems < ActiveRecord::Migration[5.0]
  def change
    add_column :package_items, :item_type, :integer, default: 0, comment: '礼包项类型，1:能量，2:功勋，3:卡牌'
    add_column :package_items, :item_count, :integer, default: 0, comment: '礼包项对应数量'

    add_index :package_items, :item_type
  end
end
