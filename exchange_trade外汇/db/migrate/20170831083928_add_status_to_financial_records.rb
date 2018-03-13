class AddStatusToFinancialRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :financial_records, :status, :integer, comment: "交易状态 0-申请成功 1-申请失败 2-入/出 金完成"
  end
end
