class AddAttackFullToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :attack_full, :integer, default: 0, comment: '攻击满值'
    add_column :cards, :attack_curr, :integer, default: 0, comment: '当前攻击值'
    add_column :cards, :control_full, :integer, default: 0, comment: '控制满值'
    add_column :cards, :control_curr, :integer, default: 0, comment: '当前控制值'
    add_column :cards, :defense_full, :integer, default: 0, comment: '防御满值'
    add_column :cards, :defense_curr, :integer, default: 0, comment: '当前防御值'
    add_column :cards, :consume_full, :integer, default: 0, comment: '消耗满值'
    add_column :cards, :consume_curr, :integer, default: 0, comment: '当前消耗值'
    add_column :cards, :cool_full, :integer, default: 0, comment: '冷却满值'
  end
end
