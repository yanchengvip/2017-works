class CreateAccountTicketBalanceDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :account_ticket_balance_details, comment: '资金变化记录表' do |t|
      t.integer :account_ticket_id, default: 0, comment: '用户微集分表id'
      t.string :user_id, comment: '用户ID'
      t.decimal :fund, precision: 10, scale: 2, comment: '资金balance变化数值'
      t.integer :trad_type, comment: '类型；1=提现,2=领取红包，3=现金红包回收'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
