class CreatePackageItems < ActiveRecord::Migration[5.0]
  def change
    create_table :package_items do |t|
      t.integer :package_id, default: 0, comment: '礼包id'
      t.string :prize_type, comment: '奖品类型'
      t.text :prize_range, comment: '奖品范围'
      t.integer :lottery_times, default: 0, comment: '抽奖次数'
      t.integer :win_count, default: 0, comment: '抽中时获得奖品份数'

      t.timestamps
    end

    add_index :package_items, :package_id
  end
end
