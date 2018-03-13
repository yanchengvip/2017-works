class AddOddsToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_box_prizes, :odds, :integer, default: 0, comment: '概率'
  end
end
