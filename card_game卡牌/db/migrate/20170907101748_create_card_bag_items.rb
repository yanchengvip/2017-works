class CreateCardBagItems < ActiveRecord::Migration[5.0]
  def change
    create_table :card_bag_items, comment: '卡包内容表' do |t|
      t.integer :card_bag_id, default: 0, comment: '卡包id'
      t.integer :card_id, default: 0, comment: '卡牌id'
      t.integer :card_num, default: 0, comment: '卡牌数量'
      t.boolean :delete_flag, default: false, comment: '删除标志，默认为0 1:已删除，0:为删除'

      t.timestamps
    end

    add_index :card_bag_items, [:card_bag_id, :card_id], unique: true
  end
end
