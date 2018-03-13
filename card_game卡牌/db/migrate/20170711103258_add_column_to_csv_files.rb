class AddColumnToCsvFiles < ActiveRecord::Migration[5.0]
  def change
    change_column :csv_files, :download_date, :datetime
  end
end
