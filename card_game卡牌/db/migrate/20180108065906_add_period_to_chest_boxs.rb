class AddPeriodToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :period, :string, default: '', comment: '宝箱期号'
  end
end
