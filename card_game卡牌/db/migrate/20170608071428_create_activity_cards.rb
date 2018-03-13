class CreateActivityCards < ActiveRecord::Migration[5.0]
  def change
    create_table :activity_cards do |t|
      t.integer :activity_id, comment: '活动id'
      t.integer :card_id, comment: '卡牌id'
      t.integer :prize_count, comment: '赠品份数'

      t.timestamps
    end

    add_index :activity_cards, :activity_id
    add_index :activity_cards, :card_id
  end
end
