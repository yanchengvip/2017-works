class AddProductIdsToChestRecords < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_records, :product_ids, :string, comment: "实物奖品ids 如 1,2,3"
  end
end
