class AddHandsToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :hands, :integer, default: 10000, comment: '宝箱手数'
  end
end
