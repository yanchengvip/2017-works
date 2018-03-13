class ChangeChestPrizesNum < ActiveRecord::Migration[5.0]
  def change
    change_column :chest_prizes, :num, :decimal, default: 0.0, precision: 10, scale: 1, comment: '数量'
  end
end
