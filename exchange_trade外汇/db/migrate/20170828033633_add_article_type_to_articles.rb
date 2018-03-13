class AddArticleTypeToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :article_type, :integer, default: 0, comment: '文章类型,1:普通新闻'
    add_column :articles, :read_num, :integer, default: 0, comment: '阅读量'
    add_column :articles, :rank, :integer, default: 0, comment: '排序'
    add_column :articles, :source, :string, comment: '来源，wisdom,新浪，微博等'
  end
end
