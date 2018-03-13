class AddIsRequireToAuctionAttributes < ActiveRecord::Migration[5.1]
  def change
    add_column :auction_attributes, :is_require, :boolean, default: false, comment: '是否必填, 默认0:非必填；1:必填'
    add_column :auction_attributes, :input_type, :integer, default: 0, comment: '填充方式，默认0，0:下拉选择框；1:输入框'
  end
end
