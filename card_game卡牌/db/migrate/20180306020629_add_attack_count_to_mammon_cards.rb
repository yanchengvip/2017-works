class AddAttackCountToMammonCards < ActiveRecord::Migration[5.0]
  def change
    add_column :mammon_cards, :attack_count, :integer, default: 1, comment: '攻击人数'
    add_column :mammon_cards, :box_percent, :decimal, precision: 5, scale: 2, default: 0, comment: '宝箱中配置比例'
  end
end
