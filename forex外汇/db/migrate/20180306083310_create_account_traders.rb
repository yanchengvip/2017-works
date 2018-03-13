class CreateAccountTraders < ActiveRecord::Migration[5.1]
  def change
    create_table :account_traders, comment: '跟投表' do |t|
      t.integer :trader_id, default: 0, comment: '交易员AccountID'
      t.integer :account_id, default: 0, comment: '跟随者AccountID'
      t.decimal :follow_amount, default: 0, precision: 16, scale: 2, comment: '跟随金额'
      t.integer :follow_type, default: 0, comment: '跟随类型 0:跟投交易员已建仓和新订单,1:仅跟投交易员开立的新订单'
      t.integer :status, default: 0, comment: '状态：0:正在跟投，1：取消跟投，2：暂停跟投'
      t.integer :dealer_id, default: 0, comment: '券商ID'
      t.integer :dealer_type, default: 1, comment: '券商类型：1:虚拟券商，2：约汇网券商'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
