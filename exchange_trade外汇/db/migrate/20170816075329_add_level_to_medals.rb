class AddLevelToMedals < ActiveRecord::Migration[5.1]
  def change
    add_column :medals, :level, :integer, defalut: 0, comment: '功勋级别'
  end
end
