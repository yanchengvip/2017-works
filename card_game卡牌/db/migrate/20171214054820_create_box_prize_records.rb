class CreateBoxPrizeRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :box_prize_records, comment: '宝箱兑奖码兑换记录表' do |t|
      t.string :user_id, default: 0, comment: '用户ID'
      t.integer :box_prize_id, default: 0, comment: 'box_prizes表ID'
      t.integer :box_prize_code_id, default: 0, comment: 'box_prize_codes表ID'
      t.string :code, comment: '兑奖码'
      t.integer :treasure_amount, default: 0, comment: '赠送付费宝箱符数量'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'
      t.timestamps
    end
    add_index :box_prize_records, :code
    add_index :box_prize_records, [:user_id, :box_prize_id, :box_prize_code_id], name: 'box_prize_records_ubb_index'
  end
end
