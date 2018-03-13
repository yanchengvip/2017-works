class ChangeShipCodeChestRecords < ActiveRecord::Migration[5.0]
  def change
    change_column :chest_records, :ship_code, :string, default: '', comment: '快递单号'
  end
end
