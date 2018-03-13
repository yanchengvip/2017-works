class ChangePeriodChestBoxs < ActiveRecord::Migration[5.0]
  def change
    change_column :chest_boxs, :period, :string, comment: '宝箱期号'
  end
end
