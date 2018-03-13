class AddGluttonSettingIdToGluttonEnergyPrizes < ActiveRecord::Migration[5.0]
  def change
    add_column :glutton_energy_prizes, :glutton_setting_id, :integer, default: 0, comment: '饕餮设置id'
    add_column :glutton_texts, :glutton_setting_id, :integer, default: 0, comment: '饕餮设置id'

    add_index :glutton_energy_prizes, :glutton_setting_id
    add_index :glutton_texts, :glutton_setting_id
  end
end
