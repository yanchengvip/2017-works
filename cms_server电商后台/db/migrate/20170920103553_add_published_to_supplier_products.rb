class AddPublishedToSupplierProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_products, :published, :boolean, default: false, comment: '是否发布，默认0:未发布'
    add_column :supplier_products, :status, :integer, default: 0, comment: '商品状态，0：初始状态，未提交审核，1:待买手审核，2:待总监审核，3:待财务审核，4:待编辑审核，5:审核结束'
    add_column :auction_products, :status, :integer, default: 0, comment: '商品状态，0：初始状态，未提交审核，1:待买手审核，2:待总监审核，3:待财务审核，4:待编辑审核，5:审核结束'

    add_index :supplier_products, :status
    add_index :auction_products, :status
  end
end
