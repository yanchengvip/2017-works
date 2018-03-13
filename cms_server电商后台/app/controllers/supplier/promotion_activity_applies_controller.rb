class Supplier::PromotionActivityAppliesController < Supplier::ApplicationController
  before_action :set_supplier_promotion_activity_apply, only: [:show, :edit, :update, :destroy, :refer_check]

  # GET /auction/promotion_activity_applies
  # GET /auction/promotion_activity_applies.json
  def index
    @supplier_promotion_activity_applies = Auction::PromotionActivityApply.where(:provider_id => current_user.id).active.ransack(params[:q]).result.includes(:promotion_activity).page(params[:page]).per(15)
  end

  # GET /auction/promotion_activity_applies/1
  # GET /auction/promotion_activity_applies/1.json
  def show
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.active.where(:promotion_activity_apply_id => params[:id]).page(params[:page]).per(15)
    @auction_apply_logs = Auction::ApplyLog.where(:apply_id => params[:id])
  end

  # GET /auction/promotion_activity_applies/new
  def new
    @supplier_promotion_activity_apply = Auction::PromotionActivityApply.new
  end

  # GET /auction/promotion_activity_applies/1/edit
  def edit
    @promotion_activity_id = @supplier_promotion_activity_apply.promotion_activity_id
    promotion = Auction::PromotionActivity.find(@supplier_promotion_activity_apply.promotion_activity_id)
    @promotion_activity_rate_of_margin = promotion.rate_of_margin
    @promotion_activity_discount_type = promotion.discount_type
    @promotion_activity_multiple_sales_discount = promotion.multiple_sales_discount
    @promotion_activity_price_off = promotion.price_off
    @promotion_activity_price_more = promotion.price_more
    @promotion_activity_pre_price_more = promotion.pre_price_more
    @promotion_activity_pre_price_off = promotion.pre_price_off
    @promotion_activity_pre_discount_total = promotion.pre_discount_total
    @supplier_products = Auction::Product.find(@supplier_promotion_activity_apply.apply_products.map{|item| item.product_id})
  end

  # POST /auction/promotion_activity_applies
  # POST /auction/promotion_activity_applies.json
  def create
    @supplier_promotion_activity_apply = Auction::PromotionActivityApply.new(auction_promotion_activity_apply_params)

    respond_to do |format|
      if @supplier_promotion_activity_apply.save
        format.html { redirect_to @supplier_promotion_activity_apply, notice: 'Promotion activity apply was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_promotion_activity_apply }
      else
        format.html { render :new }
        format.json { render json: @supplier_promotion_activity_apply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/promotion_activity_applies/1
  # PATCH/PUT /auction/promotion_activity_applies/1.json
  def update
    respond_to do |format|
      if @supplier_promotion_activity_apply.update(auction_promotion_activity_apply_params)
        format.html { redirect_to @auction_promotion_activity_apply, notice: 'Promotion activity apply was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_promotion_activity_apply }
      else
        format.html { render :edit }
        format.json { render json: @auction_promotion_activity_apply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/promotion_activity_applies/1
  # DELETE /auction/promotion_activity_applies/1.json
  def destroy
    @supplier_promotion_activity_apply.destroy
    respond_to do |format|
      format.html { redirect_to auction_promotion_activity_applies_url, notice: 'Promotion activity apply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  #提交审核
  def refer_check
    if @supplier_promotion_activity_apply.update(:status => 1)
      flash[:success] = '成功'
    else
      flash[:danger] = '失败'
    end
    redirect_to '/supplier/promotion_activity_applies'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_promotion_activity_apply
      @supplier_promotion_activity_apply = Auction::PromotionActivityApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_promotion_activity_apply_params
      params.require(:supplier_promotion_activity_apply).permit(:promotion_activity_id, :provider_id, :status, :product_count, :active, :apply_time)
    end
end
