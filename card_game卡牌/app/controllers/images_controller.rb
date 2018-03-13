class ImagesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:upload]
  def index
    @images = Image.all
  end

  def new

  end

  def upload
    id = MyUtils.generate_uuid
    @storage = $tracker.get_storage
    result = @storage.upload(params[:file])
    img_path = "/#{result[:result][:group_name]}/#{result[:result][:path]}"
    img_url = "#{FASTDFSCONFIG[:fastdfs][:tracker_url]+img_path}"
    render json: {id: id,img_url: img_url,img_path: img_path}
  end

end
