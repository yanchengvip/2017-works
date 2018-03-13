class CreateMammonPeriodItems < ActiveRecord::Migration[5.0]
  def change
    create_table :mammon_period_items, comment: '期次奖励表' do |t|
      t.integer :period_id, default: 0, comment: '期次id'
      t.integer :prize_num, default: 0, comment: '奖品等级 0,1,2,3 0:特等奖'
      t.decimal :amount, default: 0, comment: '等级基础金额'
      t.decimal :yesterday_balance, default: 0, comment: '昨日结转'
      t.decimal :today_balance, default: 0, comment: '今日结算'
      t.integer :prize_count, default: 0, comment: '奖品等级人数'
      t.boolean :delete_flag, default: false, comment: '是否删除，默认0:未删除'

      t.timestamps
    end

    add_index :mammon_period_items, :period_id
  end
end
