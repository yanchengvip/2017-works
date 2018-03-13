class Auction::PromotionActivityApplyProductsController < ApplicationController
  before_action :set_auction_promotion_activity_apply_product, only: [:edit, :update, :destroy]
  before_action :side_menus4
  # GET /auction/promotion_activity_apply_products
  # GET /auction/promotion_activity_apply_products.json
  def index
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.all
  end

  # GET /auction/promotion_activity_apply_products/1
  # GET /auction/promotion_activity_apply_products/1.json
  def show
    # ,s: 'activity_product_search'
    @bread_menu = {m1: '活动管理', m2: '活动中商品', m2_url: '/auction/promotion_activities',m3: '活动列表', s: 'activity_product_search'}
    auction_promotion_activity_apply = Auction::PromotionActivityApply.where(:status => 3, :promotion_activity_id => params[:id]).active
    params[:q][:promotion_activity_apply_id_in] = auction_promotion_activity_apply.map{|item| item.id}
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.active.where(:promotion_activity_id => params[:id]).ransack(params[:q]).result.includes(:product, :provider).page(params[:page]).per(15)
  end

  # GET /auction/promotion_activity_apply_products/new
  def new
    @auction_promotion_activity_apply_product = Auction::PromotionActivityApplyProduct.new
  end

  # GET /auction/promotion_activity_apply_products/1/edit
  def edit
  end

  # POST /auction/promotion_activity_apply_products
  # POST /auction/promotion_activity_apply_products.json
  def create
    @auction_promotion_activity_apply_product = Auction::PromotionActivityApplyProduct.new(auction_promotion_activity_apply_product_params)

    respond_to do |format|
      if @auction_promotion_activity_apply_product.save
        format.html { redirect_to @auction_promotion_activity_apply_product, notice: 'Promotion activity apply product was successfully created.' }
        format.json { render :show, status: :created, location: @auction_promotion_activity_apply_product }
      else
        format.html { render :new }
        format.json { render json: @auction_promotion_activity_apply_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/promotion_activity_apply_products/1
  # PATCH/PUT /auction/promotion_activity_apply_products/1.json
  def update
    respond_to do |format|
      if @auction_promotion_activity_apply_product.update(auction_promotion_activity_apply_product_params)
        format.html { redirect_to @auction_promotion_activity_apply_product, notice: 'Promotion activity apply product was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_promotion_activity_apply_product }
      else
        format.html { render :edit }
        format.json { render json: @auction_promotion_activity_apply_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/promotion_activity_apply_products/1
  # DELETE /auction/promotion_activity_apply_products/1.json
  def destroy
    @auction_promotion_activity_apply_product.destroy
    respond_to do |format|
      format.html { redirect_to auction_promotion_activity_apply_products_url, notice: 'Promotion activity apply product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_promotion_activity_apply_product
      @auction_promotion_activity_apply_product = Auction::PromotionActivityApplyProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_promotion_activity_apply_product_params
      params.require(:auction_promotion_activity_apply_product).permit(:promotion_activity_id, :provider_id, :active, :promotion_activity_apply_id, :product_id, :provider_price)
    end
end
