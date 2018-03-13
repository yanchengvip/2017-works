class ChangeInitTimeToCardRule < ActiveRecord::Migration[5.0]
  def change
    change_column :card_rules, :inject_energy_time, :integer, :default => 1,comment: '能量注入时间间隔/秒'
  end
end
