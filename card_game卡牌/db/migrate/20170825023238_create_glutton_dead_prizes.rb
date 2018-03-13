class CreateGluttonDeadPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :glutton_dead_prizes do |t|
      t.integer :roundth, default: 0, comment: '轮次'
      t.integer :last_blood_energy, default: 0, comment: '最后击杀饕餮的用户获得的能量'
      t.integer :max_blood_energy, default: 0, comment: '对饕餮伤害最大的用户获得的能量'
      t.boolean :delete_flag, default: false, comment: '删除状态，0:未删除，1:已删除'
      t.integer :glutton_setting_id, default: 0, comment: '饕餮设置id'

      t.timestamps
    end
  end
end
