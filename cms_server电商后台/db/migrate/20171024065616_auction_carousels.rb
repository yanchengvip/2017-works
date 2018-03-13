class AuctionCarousels < ActiveRecord::Migration[5.1]
  def change
    create_table :auction_carousels, comment: "开机轮播图" do |t|
      t.integer :version_type, comment: "1=>ios,2=>安卓"
      t.string :measurement, comment: "尺寸"
      t.boolean :active, comment: "软删", default: true
      t.string :pic, comment: "图片"
      t.timestamps
    end
  end
end
