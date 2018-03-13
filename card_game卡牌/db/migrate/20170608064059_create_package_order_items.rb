class CreatePackageOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :package_order_items do |t|
      t.integer :package_order_id, default: 0, comment: '礼包订单id'
      t.integer :user_id, default: 0, comment: '购买用户'
      t.integer :package_id, default: 0, comment: '礼包id'
      t.integer :card_id, default: 0, comment: '抽到的卡牌'
      t.integer :win_count, default: 0, comment: '抽中时获得奖品份数'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'
      # t.integer :package_item_id, default: 0, comment: '礼包项id'
      # t.string :prize_type, comment: '奖品类型'
      # t.text :prize_range, comment: '奖品范围'
      # t.integer :lottery_times, default: 0, comment: '抽奖次数'
      # t.integer :left_times, default: 0, comment: '剩余抽奖次数'

      t.timestamps
    end

    add_index :package_order_items, :package_order_id
    add_index :package_order_items, :user_id
    add_index :package_order_items, :package_id
  end
end
