class CreateChestPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_box_prizes, comment: '宝箱奖品关联表' do |t|
      t.integer :chest_box_id, default: 0, comment: '宝箱id'
      t.integer :chest_prize_id, default: 0, comment: '奖品id'
      t.integer :level, default: 0, comment: '奖品级别，1:幸运大奖，2:稀有，3:普通'
      t.integer :base_num, default: 0, comment: '奖品初始数量'
      t.integer :left_num, default: 0, comment: '奖品剩余数量'
      t.integer :worth, default: 0, comment: '奖品总价值'
      t.string :user_id, default: '', comment: '幸运大奖指定用户获得'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
    add_index :chest_box_prizes, [:chest_box_id, :chest_prize_id]
  end
end
