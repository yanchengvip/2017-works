class Image < ApplicationRecord
  belongs_to :table, polymorphic: true
   validates :url, presence: true


  #获取图片
  def self.get_image_url obj_instance
    img_urls = []
    img_path= []
    obj_instance.images.active.each do |img|
      img_urls.push(FASTDFSCONFIG[:fastdfs][:tracker_url]+img.url)
      img_path.push(img.url)
    end
    img_urls = img_urls.join(',')
    img_paths = img_path.join(',')
    images = {img_urls: img_urls,img_paths: img_paths}
  end

  #修改图片
  def self.change_image_url obj_instance,img_urls_str
    old_urls_arr = obj_instance.images.active.pluck(:url)
    new_urls_arr = img_urls_str.split(',')
    del_urls_arr = old_urls_arr - new_urls_arr
    add_urls_arr = new_urls_arr - old_urls_arr
    #删除图片
    obj_instance.images.active.where(url: del_urls_arr).each do |image|
      image.destroy!()
    end
    add_urls_arr.each do |add_url|
      #添加新图片
      obj_instance.images.create!(url: add_url)
    end
  end

end
