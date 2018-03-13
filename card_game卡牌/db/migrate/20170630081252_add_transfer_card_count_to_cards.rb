class AddTransferCardCountToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :transfer_card_count, :integer, default: 0, comment: '当transfer_type为3时，转移的卡牌数量'
  end
end
