class AddIsCodToSupplierProvier < ActiveRecord::Migration[5.1]
  def change
    change_table :supplier_providers do |t|
      t.column :is_cod, :boolean, comment: "可以货到付款", default: true
      t.column :partner_type, :integer, comment: "合伙类型 1 平台 2 代销 3 平台+代销", default: 0
      t.column :invoice_type, :integer, comment: "发票类型 1 普票 2 3%增值税 3 11%增值税 4 17%增值税", default: 0
      t.column :is_direct_ship, :boolean, comment: "直接发货", default: true
      t.column :gross_margin, :decimal, precision: 10, scale: 2, comment: "毛利率", default: 0
      t.column :active_gross_margin, :decimal, precision: 10, scale: 2, comment: "活动毛利率", default: 0
    end
  end
end
