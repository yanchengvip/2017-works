class Auction::ThemesController < ApplicationController
  before_action :set_auction_theme, only: [:show]

  #  主题列表
  #
  # GET /auction/themes
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_themes: Array<Auction::Theme>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    auction_themes = Auction::Theme.where("publish_time < ? and down_time > ? and published = true and active = true and theme_type = 0", Time.now.to_s , Time.now.to_s).order(rank: :desc)
    render json: {status: 200, msg: "成功", data: {   "auction_themes": auction_themes }}
  end

  # GET /auction/themes/1
  # GET /auction/themes/1.json
  def show
    render json: {status: 200, msg: "成功", data: @auction_theme }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_theme
      @auction_theme = Auction::Theme.find(params[:id])
    end

end
