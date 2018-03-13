class AddOrderNumToCards < ActiveRecord::Migration[5.0]
  def change
    add_column :cards, :order_num, :integer, default: 0, comment: '卡牌排序'
    add_column :cards, :video_url, :string, comment: '视频url'

    add_index :cards, :order_num
  end
end
