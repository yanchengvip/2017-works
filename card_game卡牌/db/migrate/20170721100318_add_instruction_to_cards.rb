class AddInstructionToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :instruction, :text, comment: '卡牌说明'
    add_column :cards, :rarity, :string, comment: '稀有度'
  end
end
