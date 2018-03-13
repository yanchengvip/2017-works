class CreateSupplierReportForms < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_report_forms, comment: "供应商结算单" do |t|
      t.string :provider_id, comment: "供应商ID"
      t.string :date, comment: "账单月份 如 2017-07"
      t.decimal :trade_amount, precision: 16, scale: 2, comment: "订单金额", default: 0
      t.decimal :express_amount, precision: 16, scale: 2, comment: "物流金额", default: 0
      t.decimal :other_fee, precision: 16, scale: 2, comment: "其他金额", default: 0
      t.string :remark, comment: "备注"
      t.decimal :total_amount, precision: 16, scale: 2, comment: "总金额", default: 0
      t.integer :status, comment: "状态 0 未结算 1 已结算", default: 0
      t.integer :user_id, comment: "编辑ID"

      t.timestamps
    end
  end
end
