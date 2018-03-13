class CreateBoxPrizeCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :box_prize_codes, comment: '宝箱兑奖码code表' do |t|
      t.integer :box_prize_id, comment: 'box_prizes表ID'
      t.string :code, comment: '兑奖码 16位'
      t.integer :num, default: 1, comment: '总数量'
      t.integer :use_num, default: 0, comment: '已用数量'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'
      t.timestamps
    end
    add_index :box_prize_codes, :code, :unique => true
    add_index :box_prize_codes, :box_prize_id
  end
end
