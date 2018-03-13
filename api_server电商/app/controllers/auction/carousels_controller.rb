class Auction::CarouselsController < ApplicationController

  def index
    carousels = Auction::Carousel.active.order(rank: :desc)
    carousels_ios = Rails.cache.fetch("auction_carousels_ios", expires_in: 60){
      carousels.where(version_type: 1).as_json
    }
    carousels_android = Rails.cache.fetch("auction_carousels_android", expires_in: 60){
      carousels.where(version_type: 2).as_json
    }
    render json: {status: 200, msg: "成功", data: {ios: carousels_ios , android: carousels_android}}
  end

end
