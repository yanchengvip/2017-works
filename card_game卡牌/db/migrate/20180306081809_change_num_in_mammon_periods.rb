class ChangeNumInMammonPeriods < ActiveRecord::Migration[5.0]
  def change
    change_column :mammon_periods, :num, :string, default: '', comment: '期次'
  end
end
