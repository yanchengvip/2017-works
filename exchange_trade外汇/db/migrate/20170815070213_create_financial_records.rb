class CreateFinancialRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :financial_records, comment: '出入金记录表' do |t|
      t.integer :account_id, comment: '账户id'
      t.integer :dealer_id, comment: '券商id'
      t.decimal :amount, precision: 16, scale: 6, comment: '存/取金额'
      t.decimal :balance, precision: 16, scale: 6, comment: '账户余额'
      t.string :dealer_type, comment: '关联券商类型1：模拟盘；2：wisdom'
      t.boolean :active, comment: '软删除标志'

      t.timestamps
    end

    add_index :financial_records, [:account_id, :dealer_id], name: 'fr_account_dealer_index'
  end
end
