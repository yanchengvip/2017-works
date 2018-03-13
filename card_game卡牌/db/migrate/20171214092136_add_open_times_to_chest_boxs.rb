class AddOpenTimesToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :times_max, :integer, default: 0, comment: '每用户最多开启次数'
  end
end
