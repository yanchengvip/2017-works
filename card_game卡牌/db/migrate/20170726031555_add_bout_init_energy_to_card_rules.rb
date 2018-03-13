class AddBoutInitEnergyToCardRules < ActiveRecord::Migration[5.0]
  def change
    add_column :card_rules, :init_energy, :integer,default:0,comment: '能量初始值'
    add_column :card_rules, :inject_energy_time, :integer,default:0,comment: '能量注入时间间隔/秒'
    add_column :card_rules, :inject_energy, :integer,default:0,comment: '能量注入值'
    add_column :card_rules, :max_inject_energy, :integer,default:0,comment: '能量增长上限值'

    add_index :card_rules,:bout_rank
  end
end
