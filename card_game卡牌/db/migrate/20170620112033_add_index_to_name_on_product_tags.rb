class AddIndexToNameOnProductTags < ActiveRecord::Migration[5.0]
  def change
    add_index :product_tags, :name, unique: true
  end
end
