class CreateAccountMasters < ActiveRecord::Migration[5.1]
  def change
    create_table :account_masters, comment: '账户大师关联表' do |t|
      t.integer :account_id, default: 0, comment: '账户表ID'
      t.integer :master_id, default: 0, comment: '大师账户表ID'
      t.integer :dealer_id, default: 0, comment: '券商表dealers表ID'
      t.integer :dealer_type, default: 0, comment: '关联券商类型dealer_type'
      t.string :request_ip, comment: '登录ip地址'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end

    add_index :account_masters, [:account_id, :master_id, :dealer_id],name: 'account_master_dealer_index'
  end
end
