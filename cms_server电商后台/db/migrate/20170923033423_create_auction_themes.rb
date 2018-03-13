class CreateAuctionThemes < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_themes, comment: "主题" do |t|
      t.string :title, comment: "标题", default: ""
      t.string :subtitle, comment: "副标题", default: ""
      t.string :pic, comment: "图片", default: ""
      t.datetime :publish_time, comment: "发布时间", default: "2017-01-01 00:00:00"
      t.datetime :down_time, comment: "下线时间", default: "2117-01-01 00:00:00"
      t.boolean :published, comment: "是否发布", default: true
      t.boolean :active, comment: "软删除标志", default: true
      t.string :keyword, comment: "搜索关键词", default: ""
      t.string :brand_id, comment: "品牌ID，多个用‘,’分隔", default: ""
      t.string :target, comment: "性别('men' => '男', 'women' => '女', 'nogender' => '无性别', 'children' => '儿童')", default: ""
      t.integer :unsold_count_gteq, comment: "库存数量最小值，如有库存为1， 无库存为0", default: 0
      t.string :category1_id, comment: "一级分类ID多个用‘,’分隔", default: ""
      t.string :category2_id, comment: "二级分类ID多个用‘,’分隔", default: ""
      t.string :category3_id, comment: "三级分类ID多个用‘,’分隔", default: ""
      t.string :sort_key, comment: "排序关键字 :percent 折扣, :readings_count 热度, , :arrived_at 上架时间, :price 价格, published_at: 发布时间", default: "published_at"
      t.string :sort_method, comment: "排序方式(desc, asc)", default:"desc"
      t.integer :price_gt, comment: "价格区间 最小值", default: 0
      t.integer :price_lt, comment: "价格区间 最大值", default: 1000000
      t.integer :theme_type, comment: "专题 0 闪购 1,", default: 0
      t.integer :rank, comment: "排序 小的在前", default: 1
      t.timestamps
    end
  end
end
