class CreateCardRules < ActiveRecord::Migration[5.0]
  def change
    create_table :card_rules do |t|
      t.integer :card_id, comment: '卡牌表ID'
      t.integer :bout_rank, default: 1, comment: '第几轮'
      t.integer :card_consume_energy, default: 0, comment: '每次使用需消耗能量'
      t.string  :flag, comment: '卡牌规则唯一标记'
      t.boolean :delete_flag, default: 0, comment: '删除标志 0：未删除，1：已删除'
    end
  end
end
