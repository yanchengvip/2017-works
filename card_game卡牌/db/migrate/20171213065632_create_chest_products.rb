class CreateChestProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :chest_prizes, comment: '奖品表' do |t|
      t.string :name, default: '', comment: '奖品名称'
      t.integer :prize_type, default: 0, comment: '奖品类型, 1:实物,2:入场券，3:兑奖券，4:参赛券，5:宝箱券'
      t.integer :num, default: 0, comment: '数量'
      t.integer :price, default: 0, comment: '奖品价值'
      t.string :thumbnail, default: '', comment: '奖品图片'
      t.string :win_copy, comment: '中奖文案'
      t.integer :share_num, default: 0, comment: '分享奖励的宝箱券数量'
      t.integer :jump_type, default: 0, comment: '获取后，跳转场景，1:抢兑商品，2:兑奖阁，3:领取录入，4:确认（回到宝箱页面）'

      t.integer :table_id, default: 0, comment: '奖品对应id（锦囊、参赛券、商品对应id）'
      t.string :table_type, default: '', comment: '奖品对应model, GameProp或...'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认0:未删除，1:已删除'

      t.timestamps
    end

    add_index :chest_prizes, :table_id
  end
end
