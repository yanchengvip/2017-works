class CreateAccountTactics < ActiveRecord::Migration[5.1]
  def change
    create_table :account_tactics, comment: '账户策略表' do |t|
      t.integer :account_id, comment: "账户id"
      t.integer :tactic_id, comment: "策略表ID"
      t.decimal :follow_money, precision: 16, scale: 6, comment: "跟随金额"
      t.string :dealer_type, comment: "关联券商类型,账户来源1：模拟盘；2：wisdom"
      t.integer :dealer_id, comment: "关联券商id"
      t.boolean :active, comment: "软删除标志"

      t.timestamps
    end

    add_index :account_tactics, [:account_id, :tactic_id, :dealer_id], name: 'account_tactic_index'
  end
end
