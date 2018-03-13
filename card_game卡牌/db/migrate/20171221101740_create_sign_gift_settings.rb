class CreateSignGiftSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :sign_gift_settings do |t|
      t.integer :running_days, default: 1, comment: '连续登陆天数'
      t.integer :amount, default: 0, comment: '获得奖品数量'
      t.integer :gift_type, default: 0, comment: '奖品类型 1=免费宝相符'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'
      t.timestamps
    end
    add_index :sign_records, :running_days
  end
end
