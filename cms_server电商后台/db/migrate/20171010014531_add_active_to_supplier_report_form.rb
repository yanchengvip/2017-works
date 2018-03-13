class AddActiveToSupplierReportForm < ActiveRecord::Migration[5.1]
  def change
    add_column :supplier_report_forms, :active, :boolean, comment: '软删除标志'
  end
end
