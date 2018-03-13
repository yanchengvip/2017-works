class CreateAuctionPicAds < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_pic_ads, comment: "首页轮播图片" do |t|
      t.string :title, comment: "标题", default: ""
      t.string :pic, comment: "图片地址", default: ""
      t.datetime :publish_time, comment: "上线时间", default: " 2017-01-01 00:00:00", index: true
      t.datetime :down_time, comment: "下线时间", default: " 2117-01-01 00:00:00", index: true
      t.boolean :published, comment: "是否发布", default: true
      t.integer :link_type, comment: "链接类型1:专题, 2: 商品, 3:外部链接 ", default: 0
      t.string :link_url, comment: "链接地址（专题、商品 是ID值）", default: ""
      t.boolean :active, comment: "软删除标志", default: true

      t.timestamps
    end
  end
end
