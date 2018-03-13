class Auction::PicAdsController < ApplicationController
  before_action :set_auction_pic_ad, only: [:show, :edit, :update, :destroy]


  #  首页列表
  #
  # GET /auction/pic_ads
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_pic_ads: Array<Auction::PicAd>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    # auction_pic_ads = Auction::PicAd.where({},{},{page: params[:page], per_page: params[:per_page]})
    render json: {status: 200, msg: "成功", data: {   "auction_pic_ads": [
            {
                "title": "主题",
                "pic": "www.baidu.com",
                "published": true,
                "publish_time": "2017-01-01 00:00:00",
                "down_time": "2017-01-01 00:00:00",
                "link_type": 1,
                "link_url": "www.baidu.com"
            }
        ] }}
  end

  #返回秒杀首页主题
  def ad_seckill_theme
    home = {
      "auction_pic_ads": Auction::PicAd.includes(:auction_theme).where("publish_time < ? and down_time > ? and published = true and active = true", Time.now.to_s , Time.now.to_s).order(sort_field: :desc).as_json({include:{auction_theme: {only: [:id, :search_params]}}}).map{|x| x.delete("auction_theme") if x["link_type"] != 1; x},
      "auction_seckills": Auction::Seckill.where("date = ? and active = true", Date.today.to_s),
      "auction_themes": Auction::Theme.where("publish_time < ? and down_time > ? and published = true and active = true and theme_type = 0", Time.now.to_s , Time.now.to_s).order(rank: :desc).as_json(Auction::Theme.xml_options),
      "app_bar": Auction::Theme.where("publish_time < ? and down_time > ? and published = true and active = true and theme_type = 2", Time.now.to_s , Time.now.to_s).order(rank: :desc).as_json(Auction::Theme.xml_options),
      "pc_flash_buy": Auction::Theme.where("publish_time < ? and down_time > ? and published = true and active = true and theme_type = 1", Time.now.to_s , Time.now.to_s).order(rank: :desc).as_json(Auction::Theme.xml_options)
    }

    render json: {status: 200, msg: "成功", data: home}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_pic_ad
      @auction_pic_ad = Auction::PicAd.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_pic_ad_params
      params.require(:auction_pic_ad).permit(:title, :pic, :publish_time, :down_time, :published, :link_type, :link_url, :active)
    end
end
