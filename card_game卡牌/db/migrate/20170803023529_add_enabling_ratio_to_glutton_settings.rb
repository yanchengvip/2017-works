class AddEnablingRatioToGluttonSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :glutton_settings, :immune_seal_ratio, :decimal, precision: 4, scale: 2, default: 0, comment: '免疫封印法阵条件系数'
    add_column :glutton_settings, :enabling_ratio, :decimal, precision: 4, scale: 2, default: 0, comment: '解除封印能量系数'
    add_column :glutton_settings, :offer_energy_percent, :decimal, precision: 4, scale: 3, default: 0, comment: '用户解除封印时贡献给攻打饕餮消耗能量前三用户的百分比'
    add_column :glutton_settings, :appear_text, :string, default: '', comment: '饕餮出现时，提示语言'
    add_column :glutton_settings, :gonna_appear_text, :string, default: '', comment: '饕餮将要出现时，提示语言'
    add_column :glutton_settings, :zero_blood_text, :string, default: '', comment: '饕餮血量为0时，提示语言'
    add_column :glutton_settings, :broadcast_blood, :decimal, precision: 4, scale: 3, default: 0, comment: '当饕餮血量低于X百分比时，触发广播'
    add_column :glutton_settings, :broadcast_key, :decimal, precision: 4, scale: 3, default: 0, comment: '当饕餮拥有密钥大于X百分比时，触发广播'
    add_column :glutton_settings, :broadcast_text, :string, default: '', comment: '广播提示语言'
    # remove_column :glutton_settings, :round_blood
  end
end
