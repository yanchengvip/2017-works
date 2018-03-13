class AddIsProgramToMammonAttackRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :mammon_attack_records, :is_program, :boolean, default: false, comment: "程序还是用户出牌 用户false 程序 true"
  end
end
