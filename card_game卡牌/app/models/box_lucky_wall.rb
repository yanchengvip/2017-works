class BoxLuckyWall < ApplicationRecord

  after_save :resize_image
  def resize_image
    require "mini_magick"
    if self.image_changed?
      img_url = FASTDFSCONFIG[:fastdfs][:tracker_url] + self.image

      image_114 = MiniMagick::Image.open img_url
      image_114.resize "114x114"

      image_267 = MiniMagick::Image.open img_url
      image_267.resize "267x267"

      @storage = $tracker.get_storage
      res_114 = @storage.upload File.open(image_114.path)
      res_267 = @storage.upload File.open(image_267.path)

      self.update_columns(t114: "/#{res_114[:result][:group_name]}/#{res_114[:result][:path]}", t267: "/#{res_267[:result][:group_name]}/#{res_267[:result][:path]}")

    end
  end

end
