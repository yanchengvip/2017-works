class CreateTacticProfits < ActiveRecord::Migration[5.1]
  def change
    create_table :tactic_profits, comment: '策略跟随者收益明细' do |t|
      t.integer :account_id, default: 0, comment: '账户ID'
      t.integer :tactic_id, default: 0, comment: '策略ID'
      t.string :tactic_flag, default: 0, comment: '策略唯一标识符'
      t.decimal :amount, default: 0, precision: 16, scale: 6, comment: '收益;+-'
      t.datetime :date, comment: '日期'
      t.integer :dealer_type, default: 0, comment: '关联券商类型1：模拟盘；2：wisdom'
      t.integer :dealer_id, comment: '关联券商id'
      t.boolean :active, comment: '软删除标志'

      t.timestamps
    end

    add_index :tactic_profits, [:account_id, :tactic_id, :dealer_id], name: 'atd_index'
    add_index :tactic_profits, [:account_id, :tactic_flag, :dealer_id], name: 'tp_atd_index'
  end
end
