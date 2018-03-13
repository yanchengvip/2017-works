class Supplier::ImagesController < Supplier::ApplicationController
  # skip_before_action :verify_authenticity_token, only: [:upload]
  def index
    @images = Auction::Image.all
  end

  def new

  end

  def upload
    id = SecureRandom.hex(8)
    uploader = ImageUploader.new(params[:model_name])
    uploader.store!(params[:file])
    # image_path = '/' + uploader.store_dir + "/#{uploader.filename}"
    image_path = uploader.url

    return render json: {"id": id, "img_url": image_path, "img_path": image_path}
  end

end
