class CreatePackages < ActiveRecord::Migration[5.0]
  def change
    create_table :packages do |t|
      t.string :name, comment: '礼包名称'
      t.integer :package_type_id, default: 0, comment: '礼包分类id'
      t.decimal :price, precision: 10, scale: 2, default: 0, comment: '价格'
      t.text :summary, comment: '简介'
      t.integer :status, default: 0, comment: '上下架状态 -1:已下架，0:未上架，1:已上架'
      t.datetime :onshelf_time, comment: '上架时间'
      t.datetime :offshelf_time, comment: '下架时间'
      t.string :icon_url, comment: '缩略图'
      t.text :details, comment: '详细介绍'
      t.integer :total_count, default: 0, comment: '投放总量'
      t.integer :total_limit, default: 0, comment: '每ID总限购'
      t.integer :saled_count, default: 0, comment: '销量'
      t.integer :left_count, default: 0, comment: '剩余库存'
      t.integer :day_limit, default: 0, comment: '每ID每天限购'
      t.integer :prize_type, default: 0, comment: '中奖类型 1:固定礼包，2:随机礼包'
      t.boolean :delete_flag, default: 0, comment: '删除标志，1 删除'

      t.timestamps
    end
  end
end
