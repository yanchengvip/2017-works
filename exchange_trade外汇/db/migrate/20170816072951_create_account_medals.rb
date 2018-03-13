class CreateAccountMedals < ActiveRecord::Migration[5.1]
  def change
    create_table :account_medals, comment: '账户功勋表' do |t|
      t.integer :account_id, default: 0, comment: '账户ID'
      t.integer :medal_id, default: 0, comment: '功勋ID'
      t.integer :medal_type, default: 0, comment: '功勋类型'
      t.boolean :active, default: true, comment: '软删除标志'
      t.datetime :achieve_time, comment: '获取功勋时间'

      t.timestamps
    end


    add_index :account_medals, [:account_id, :medal_id], name: 'account_medal_index'
  end
end
