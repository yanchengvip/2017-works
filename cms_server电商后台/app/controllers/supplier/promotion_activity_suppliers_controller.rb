class Supplier::PromotionActivitySuppliersController < Supplier::ApplicationController
  before_action :set_supplier_promotion_activity, only: [:show, :edit, :update, :destroy]
  def index
    auction_promotion_activity = Auction::PromotionActivity.where("status in (3,4)").active
    params[:q][:promotion_activity_id_in] = auction_promotion_activity.map{|item| item.id}
    @supplier_promotion_activity = Auction::PromotionActivitySupplier.where(:supplier_id => current_user.id).active.ransack(params[:q]).result.includes(:promotion_activity).page(params[:page]).per(15)
  end
  #未开始
  def no_begin_activity
    auction_promotion_activity = Auction::PromotionActivity.where("status = 3 and promotion_begin > ? ", Time.now).active
    params[:q][:promotion_activity_id_in] = auction_promotion_activity.map{|item| item.id}
    @supplier_promotion_activity = Auction::PromotionActivitySupplier.where(:supplier_id => current_user.id).active.ransack(params[:q]).result.includes(:promotion_activity).page(params[:page]).per(15)
    render :index
  end
  #进行中
  def proceed_activity
    auction_promotion_activity = Auction::PromotionActivity.where("status = 3 and promotion_end > ? and promotion_begin < ?", Time.now, Time.now).active
    params[:q][:promotion_activity_id_in] = auction_promotion_activity.map{|item| item.id}
    @supplier_promotion_activity = Auction::PromotionActivitySupplier.where(:supplier_id => current_user.id).active.ransack(params[:q]).result.includes(:promotion_activity).page(params[:page]).per(15)
    render :index
  end
  #已结束
  def end_activity
    auction_promotion_activity = Auction::PromotionActivity.where("status = 3 and promotion_end < ?", Time.now).active
    auction_promotion_activitys = Auction::PromotionActivity.where(:status => 4).active
    params[:q][:promotion_activity_id_in] = auction_promotion_activity.map{|item| item.id} + auction_promotion_activitys.map{|item| item.id}
    @supplier_promotion_activity = Auction::PromotionActivitySupplier.where(:supplier_id => current_user.id).active.ransack(params[:q]).result.includes(:promotion_activity).page(params[:page]).per(15)
    render :index
  end

  def show
  end
  #申报商品
  def report_product
    @promotion_activity_id = params[:promotion_activity_id]#活动id
    @promotion_activity_rate_of_margin = params[:promotion_activity_rate_of_margin]
    @promotion_activity_discount_type = params[:promotion_activity_discount_type]
    @promotion_activity_multiple_sales_discount = params[:promotion_activity_multiple_sales_discount]
    @promotion_activity_price_off = params[:promotion_activity_price_off]
    @promotion_activity_price_more = params[:promotion_activity_price_more]

    @promotion_activity_pre_price_more = params[:promotion_activity_pre_price_more]
    @promotion_activity_pre_price_off = params[:promotion_activity_pre_price_off]
    @promotion_activity_pre_discount_total = params[:promotion_activity_pre_discount_total]
    # auction_promotion_activity = Auction::PromotionActivity.find(params[:promotion_activity_id])
    # auction_promotion_activity.update(:status => 1)
    render :apply_product
  end
  #批量查询
  def batch_search
    @promotion_activity_id = params[:promotion_activity_id]
    @promotion_activity_rate_of_margin = params[:promotion_activity_rate_of_margin]
    @promotion_activity_discount_type = params[:promotion_activity_discount_type]
    @promotion_activity_multiple_sales_discount = params[:promotion_activity_multiple_sales_discount]
    @promotion_activity_price_off = params[:promotion_activity_price_off]
    @promotion_activity_price_more = params[:promotion_activity_price_more]
    @promotion_activity_pre_price_more = params[:promotion_activity_pre_price_more]
    @promotion_activity_pre_price_off = params[:promotion_activity_pre_price_off]
    @promotion_activity_pre_discount_total = params[:promotion_activity_pre_discount_total]
    params[:q] ||= {}
    params[:q][:id_in] = params[:pids].gsub(/\s+/,'').split(",") if params[:pids] && params[:pids].is_a?(String)
    @q = Auction::Product.active.ransack(params[:q])
    @supplier_products = @q.result.includes(:brand, :skus, :promotion_activity)
    render "_product_search"
  end
  #申报商品
  def apply_product
    promotion_activity_id = params[:promotion_activity_id]
    auction_promotion_activity = Auction::PromotionActivity.find(promotion_activity_id)
    @auction_promotion_activity_apply = Auction::PromotionActivityApply.create(:promotion_activity_id => promotion_activity_id, :provider_id => current_user.id, :apply_time => Time.now, :product_count => params[:product][:id].split(",").length)
    params[:product][:id].split(",").each_with_index do |id, index|
      product = Auction::Product.find(id)
      Auction::PromotionActivityApplyProduct.create(:promotion_activity_id => promotion_activity_id, :provider_id => current_user.id, :promotion_activity_apply_id => @auction_promotion_activity_apply.id, :product_id => id, :provider_price => params[:product][:provider_price].split(",")[index])
      product.update(:promotion_activity_id => promotion_activity_id, :promotion_activity_begin => auction_promotion_activity.promotion_begin,:promotion_activity_end => auction_promotion_activity.promotion_end,:promotion_provider_price => params[:product][:provider_price].split(",")[index])
    end
    return render json: {status: 200, msg: '申报成功'}
  end

  def choose_product
    params[:q] ||= {}
    params[:q][:id_in] = params[:pids].gsub(/\s+/,'').split(",") if params[:pids] && params[:pids].is_a?(String)
    @q = Auction::Product.active.ransack(params[:q])
    @choose_supplier_products = @q.result.includes(:brand, :skus)
    render partial: 'product'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_promotion_activity
      @supplier_promotion_activity = Auction::PromotionActivitySupplier.find(params[:id])
    end


end
