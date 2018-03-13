class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles, comment: '新闻' do |t|
      t.string :title, comment: '标题'
      t.datetime :published_at, comment: '发布时间'
      t.text :content, comment: '内容'
      t.boolean :active, default: true, comment: '软删'
      t.boolean :published, default: false, comment: '是否发布'
      t.text :from_url, comment: '抓取地址', limit: 2048
      t.text :img, comment: '大图'

      t.timestamps
    end
  end
end
