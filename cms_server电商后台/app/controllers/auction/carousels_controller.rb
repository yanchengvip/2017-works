class Auction::CarouselsController < ApplicationController
  before_action :set_auction_carousel, only: [:show, :edit, :update, :destroy]
  before_action :side_menus4

  # GET /auction_carousels
  # GET /auction_carousels.json
  def index
    @bread_menu = {m1: '开机轮播图管理', m2: '开机轮播图管理', m2_url: '/auction/carousels', m3: '开机轮播图列表', add: '/auction/carousels/new'}
    @auction_carousels = Auction::Carousel.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction_carousels/1
  # GET /auction_carousels/1.json
  def show
  end

  # GET /auction_carousels/new
  def new
    @bread_menu = {m1: '开机轮播图管理', m2: '开机轮播图管理', m2_url: '/auction/carousels', m3: '新增轮播图'}
    @auction_carousel = Auction::Carousel.new
    @auction_carousel_version_type = Auction::Carousel::VERSIONTYPE.invert.to_a
  end

  # GET /auction_carousels/1/edit
  def edit
    @auction_carousel_version_type = Auction::Carousel::VERSIONTYPE.invert.to_a
  end

  # POST /auction_carousels
  # POST /auction_carousels.json
  def create
    @auction_carousel = Auction::Carousel.new(auction_carousel_params)
    if @auction_carousel.save
      flash[:success] = '添加成功'
    else
      flash[:error] = '添加失败'
    end
    redirect_to '/auction/carousels'
  end

  # PATCH/PUT /auction_carousels/1
  # PATCH/PUT /auction_carousels/1.json
  def update
    if @auction_carousel.update(auction_carousel_params)
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/auction/carousels'
  end

  # DELETE /auction_carousels/1
  # DELETE /auction_carousels/1.json
  def destroy
    @auction_carousel.destroy
    respond_to do |format|
      format.html { redirect_to auction_carousels_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_carousel
      @auction_carousel = Auction::Carousel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_carousel_params
      # params.fetch(:auction_carousel, {})
      params.require(:auction_carousel).permit!
    end
end
