class RenameTypeToFinancialRecords < ActiveRecord::Migration[5.1]
  def change
    rename_column :financial_records, :type, :fr_type
  end
end
