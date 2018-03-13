class AddTypeToFinancialRecords < ActiveRecord::Migration[5.1]
  def change
    add_column :financial_records, :type, :integer, default: 0, comment: "入金 1， 出金2"
  end
end
