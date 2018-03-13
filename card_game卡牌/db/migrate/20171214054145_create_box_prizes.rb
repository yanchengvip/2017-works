class CreateBoxPrizes < ActiveRecord::Migration[5.0]
  def change
    create_table :box_prizes, comment: '宝箱兑奖码' do |t|
      t.string :name, comment: '名称'
      t.integer :treasure_amount, default: 0, comment: '赠送付费宝箱符数量'
      t.date :valid_date, comment: '有效期'
      t.integer :limit_num, default: 0, comment: 'ID使用上限/次数'
      t.string :remark, comment: '说明'
      t.integer :prize_type,  default: 0, comment: '类型: 1=独立兑奖码,2=复用兑奖码'
      t.integer :status, default: 1, comment: '1=启用,2=禁用'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'
      t.timestamps
    end
  end
end
