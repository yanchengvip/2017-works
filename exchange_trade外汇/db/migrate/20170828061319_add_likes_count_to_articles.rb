class AddLikesCountToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :likes_count, :integer, default: 0, comment: '点赞数'
    add_column :comments, :likes_count, :integer, default: 0, comment: '点赞数'
  end
end
