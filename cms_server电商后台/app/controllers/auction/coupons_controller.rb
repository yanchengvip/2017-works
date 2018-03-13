class Auction::CouponsController < ApplicationController
  before_action :set_auction_coupon, only: [:show, :edit, :update, :destroy, :published]
  before_action :side_menus4

  # GET /auction/coupons
  # GET /auction/coupons.json
  def index
    @bread_menu = {m1: '优惠券管理', m2: '优惠券管理', m2_url: '/auction/coupons', add: '/auction/coupons/new', s: 'coupon_search'}
    @auction_coupons = Auction::Coupon.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/coupons/1
  # GET /auction/coupons/1.json
  def show
  end

  # GET /auction/coupons/new
  def new
    @bread_menu = {m1: '优惠券管理', m2: '优惠券管理', m2_url: '/auction/coupons',m3: '新增优惠券', add: '/auction/coupons/new'}
    @auction_coupon = Auction::Coupon.new
    @auction_coupon_functions = Auction::Coupon::FUNCTION.invert.to_a
  end

  # GET /auction/coupons/1/edit
  def edit
    @auction_coupon_functions = Auction::Coupon::FUNCTION.invert.to_a
  end
  #发布
  def published
    if @auction_coupon.update(:published => true)
      flash[:success] = '发布成功'
    else
      flash[:error] = '发布失败'
    end
    redirect_to '/auction/coupons'
  end

  # POST /auction/coupons
  # POST /auction/coupons.json
  def create
    @auction_coupon = Auction::Coupon.new(auction_coupon_params)
    if @auction_coupon.save
      flash[:success] = '添加成功'
    else
      flash[:error] = '添加失败'
    end
    redirect_to '/auction/coupons'
  end

  # PATCH/PUT /auction/coupons/1
  # PATCH/PUT /auction/coupons/1.json
  def update
    if @auction_coupon.update(auction_coupon_params)
      flash[:success] = '编辑成功'
    else
      flash[:error] = '编辑失败'
    end
    redirect_to '/auction/coupons'
  end

  # DELETE /auction/coupons/1
  # DELETE /auction/coupons/1.json
  def destroy
    @auction_coupon.destroy
    respond_to do |format|
      format.html { redirect_to auction_coupons_url, notice: 'Coupon was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_coupon
      @auction_coupon = Auction::Coupon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_coupon_params
      # params.fetch(:auction_coupon, {})
      params.require(:auction_coupon).permit!
    end
end
