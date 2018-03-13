class Auction::PromotionActivityAppliesController < ApplicationController
  before_action :set_auction_promotion_activity_apply, only: [:show, :edit, :update, :destroy]
  before_action :side_menus4

  # GET /auction/promotion_activity_applies
  # GET /auction/promotion_activity_applies.json
  def index
    @bread_menu = {m1: '活动商品审批管理', m2: '活动商品审批管理', m2_url: '/auction/promotion_activity_applies', m3: '审批列表', s: 'activity_apply_search'}
    @auction_promotion_activity_applies = Auction::PromotionActivityApply.where("status != 0").active.ransack(params[:q]).result.includes(:promotion_activity, :provider).page(params[:page]).per(15)
  end

  # GET /auction/promotion_activity_applies/1
  # GET /auction/promotion_activity_applies/1.json
  def show
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.active.where(:promotion_activity_apply_id => params[:id]).page(params[:page]).per(15)
    @auction_apply_logs = Auction::ApplyLog.where(:apply_id => params[:id])
  end

  def good_approved
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.active.where(:promotion_activity_apply_id => params[:id]).page(params[:page]).per(15)
    @auction_apply_logs = Auction::ApplyLog.where(:apply_id => params[:id])
  end

  def good_audit
    auction_promotion_activity_apply = Auction::PromotionActivityApply.find(params[:apply_id])
    auction_promotion_activity_apply.update(:status => 3)
    Auction::ApplyLog.create(:apply_id => params[:apply_id], :user_id => current_user.id, :content => params[:content], :check_result => "通过" , :check_time => Time.now)
    redirect_to '/auction/promotion_activity_applies'
  end

  def good_audit_unpass
    auction_promotion_activity_apply = Auction::PromotionActivityApply.find(params[:apply_id])
    auction_promotion_activity_apply.update(:status => 2)
    Auction::ApplyLog.create(:apply_id => params[:apply_id], :user_id => current_user.id, :content => params[:content], :check_result => "驳回" , :check_time => Time.now)
    redirect_to '/auction/promotion_activity_applies'
  end

  # GET /auction/promotion_activity_applies/new
  def new
    @auction_promotion_activity_apply = Auction::PromotionActivityApply.new
  end

  # GET /auction/promotion_activity_applies/1/edit
  def edit
  end

  # POST /auction/promotion_activity_applies
  # POST /auction/promotion_activity_applies.json
  def create
    @auction_promotion_activity_apply = Auction::PromotionActivityApply.new(auction_promotion_activity_apply_params)

    respond_to do |format|
      if @auction_promotion_activity_apply.save
        format.html { redirect_to @auction_promotion_activity_apply, notice: 'Promotion activity apply was successfully created.' }
        format.json { render :show, status: :created, location: @auction_promotion_activity_apply }
      else
        format.html { render :new }
        format.json { render json: @auction_promotion_activity_apply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/promotion_activity_applies/1
  # PATCH/PUT /auction/promotion_activity_applies/1.json
  def update
    respond_to do |format|
      if @auction_promotion_activity_apply.update(auction_promotion_activity_apply_params)
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
    @auction_promotion_activity_apply.destroy
    respond_to do |format|
      format.html { redirect_to auction_promotion_activity_applies_url, notice: 'Promotion activity apply was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_promotion_activity_apply
      @auction_promotion_activity_apply = Auction::PromotionActivityApply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_promotion_activity_apply_params
      params.require(:auction_promotion_activity_apply).permit(:promotion_activity_id, :provider_id, :status, :product_count, :active, :apply_time)
    end
end
