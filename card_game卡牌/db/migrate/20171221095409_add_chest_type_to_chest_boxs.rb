class AddChestTypeToChestBoxs < ActiveRecord::Migration[5.0]
  def change
    add_column :chest_boxs, :chest_type, :integer, default: 0, comment: '宝箱类型，1:青铜，2:白银，3:黄金，4:白金'
    add_column :chest_boxs, :open_type, :integer, default: 0, comment: '打开方式，1:使用免费次数开启，2:使用宝符开启，花费数量对应treasure_amount字段'
    # add_column :chest_boxs, :cost_num, :integer, default: 0, comment: '使用选择的打开方式开启宝箱，需要花费的数量'
  end
end
