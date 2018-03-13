class CreateAdverts < ActiveRecord::Migration[5.1]
  def change
    create_table :adverts,comment: '广告表' do |t|
      t.string :title, comment: '标题'
      t.integer :advert_type, default: 0, comment: '类型;0:无，1:首页轮播,2:启动图'
      t.text :img, comment: '图片'
      t.text :from_url, comment: '来源地址'
      t.integer :rank, default: 0, comment: '排序'
      t.text :remark, comment: '备注'
      t.boolean :published, default: false, comment: '是否发布'
      t.datetime :published_at, comment: '发布时间'
      t.boolean :active, default: true, comment: '软删'

      t.timestamps
    end
  end
end
