class ChangeCardTypeIdCards < ActiveRecord::Migration[5.0]
  def change
    rename_column :cards, :card_type_id, :card_type
    drop_table :card_types
  end
end
