class CreateGluttonEnergyPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :glutton_energy_prizes do |t|
      t.decimal :blood_percent, precision: 4, scale: 3, default: 0, comment: '饕餮血量百分比'
      t.decimal :energy_percent, precision: 4, scale: 3, default: 0, comment: '临界点能量奖励数量（=当前回合饕餮血量上限百分比）'
      t.boolean :delete_flag, default: false, comment: '删除标志 0:未删除，1:已删除'

      t.timestamps
    end
  end
end
