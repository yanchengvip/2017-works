class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :name, comment: '卡牌名称'
      t.decimal :price, precision: 10, scale: 2, default: 0, comment: '卡牌价格(微集分)'
      t.integer :card_type_id, default: 0, comment: '卡牌类型 1:进攻卡，2:防御卡，3:控制卡，4:史诗类'
      t.string :summary, comment: '卡牌简介'
      t.string :icon_url, comment: '卡牌ICON'
      t.text :details, comment: '详细介绍'
      t.integer :cooldown, default: 0, comment: '卡牌冷却CD'
      t.text :effect, comment: '使用效果'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'

      t.timestamps
    end

    add_index :cards, :card_type_id
  end
end
