class CreateMammonUserWinnings < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_user_winnings, comment: '中奖明细' do |t|
      t.integer :mammon_period_item_id, default: 0, comment: '期次奖励ID'
      t.string :user_id, comment: '用户ID'
      t.integer :period_id, default: 0, comment: '期次ID'
      t.string :code, comment: '中奖号码'
      t.decimal :amount, precision: 15, scale: 2, default: 0, comment: '中奖金额'
      t.integer :prize_num, comment: '中奖等级0,1,2,3 统计'
      t.integer :status, default: 1, comment: '是否领取;1=否,2=已领取'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end
  end
end
