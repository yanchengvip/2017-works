class AddAutoInEnergyMinToWebSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :web_settings, :auto_energy_min, :integer, default: 0, comment: '自动报名最小能量值'
  end
end
