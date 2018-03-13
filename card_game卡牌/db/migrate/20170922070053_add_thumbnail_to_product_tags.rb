class AddThumbnailToProductTags < ActiveRecord::Migration[5.0]
  def change
    add_column :product_tags, :thumbnail, :string, default: '', comment: '分类图片'
  end
end
