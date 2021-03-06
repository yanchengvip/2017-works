class CreateSupplierProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_products, comment: "供应商-商品" do |t|
      t.string :name, comment: "名称"
      t.text :description, comment: "描述"
      t.integer :price, comment: "市场价"
      t.integer :discount, comment: "销售价"
      t.integer :provider_price, comment: "供应商结算价"
      t.string :spec_pic, comment: "尺寸说明图片"
      t.string :color_pic, comment: "颜色图片"
      t.string :color_name, comment: "颜色名称"
      t.string :identifier, comment: "编号-原厂货号"
      t.string :keywords, comment: "关键字"
      t.string :relate_product_ids, comment: "相关产品ID列表"
      t.integer :category1_id, comment: "一级分类"
      t.integer :category2_id, comment: "二级分类"
      t.integer :brand_id, comment: "品牌"
      t.datetime :published_at, comment: "发布时间"
      # t.string :color, comment: "颜色"
      # t.string :recommend, comment: "推荐"
      t.string :target, comment: "对象"
      t.text :match_product_ids, comment: "搭配产品ID列表"
      t.string :major_pic, comment: "主图片"
      t.string :remark, comment: "备注"
      t.string :label, comment: "标注"
      t.string :prefix, comment: "前缀"
      # t.string :origins, comment: "产地列表"
      # t.string :background, comment: "背景图片"
      # t.string :model_pic, comment: "模特图片"
      t.integer :category3_id, comment: "三级分类"
      # t.string :thickness, comment: "厚度"
      # t.string :elasticity, comment: "弹力"
      # t.string :pliability, comment: "柔软"
      t.string :remark2, comment: "备注2"
      # t.string :texture, comment: "材质"
      t.boolean :foreign_payment, comment: "是否跨境商品 false 国内"
      t.string :keywords2, comment: "关键字2"
      t.boolean :use_voucher, default: false, comment: "是否禁止用券"
      t.integer :percent, comment: "折扣"
      t.integer :provider_id, comment: "供应商ID"

      t.timestamps
    end
  end
end
