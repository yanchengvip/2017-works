class CreateSignRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :sign_records do |t|
      t.integer :user_id, comment: '用户ID'
      t.date :sign_date, comment: '登陆日期'
      t.integer :running_days, default: 1, comment: '连续登陆天数'
      t.integer :amount, default: 0, comment: '获得奖品数量'
      t.integer :gift_type, default: 0, comment: '奖品类型 1=免费宝相符'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'
      t.timestamps
    end

    add_index :sign_records, :user_id
  end
end
