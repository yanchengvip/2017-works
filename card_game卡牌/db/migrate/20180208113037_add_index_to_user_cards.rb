class AddIndexToUserCards < ActiveRecord::Migration[5.0]
  def change
    add_index :mammon_user_cards, [:user_id, :card_id, :period_id], unique: true
  end
end
