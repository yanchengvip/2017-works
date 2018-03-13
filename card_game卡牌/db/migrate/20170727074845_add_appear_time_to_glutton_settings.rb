class AddAppearTimeToGluttonSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :glutton_settings, :appear_time, :integer, default: 0, comment: '每轮开始后X秒，饕餮出现在战场中'
    add_column :glutton_settings, :attack_time, :integer, default: 0, comment: '饕餮出现后，每隔X秒攻击所有用户1次'
    add_column :glutton_settings, :attack_user_key, :decimal, precision: 3, scale: 2, default: 0, comment: '饕餮每次攻击获取的每个用户的密钥数量百分比'
    add_column :glutton_settings, :round_blood, :integer, default: 0, comment: '饕餮出现后，每轮的血量，逗号隔开如：1,2,3,4,5,6'
    add_column :glutton_settings, :last_blood_energy, :integer, default: 0, comment: '最后击杀饕餮的用户获得的能量'
    add_column :glutton_settings, :max_blood_energy, :integer, default: 0, comment: '对饕餮伤害最大的用户获得的能量'
    add_column :glutton_settings, :restart_time, :integer, default: 0, comment: '当饕餮拥有100%密钥且持续 X 秒，重新开启战役'

    remove_column :glutton_settings, :forage_count
    remove_column :glutton_settings, :gain_user_key
    remove_column :glutton_settings, :show_text

  end
end
