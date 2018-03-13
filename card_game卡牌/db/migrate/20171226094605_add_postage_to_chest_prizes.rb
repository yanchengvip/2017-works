class AddPostageToChestPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_prizes, :postage, :integer, default: 0, comment: '快递费'
  end
end
