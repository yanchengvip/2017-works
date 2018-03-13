class Supplier::PromotionActivityApplyProductsController < Supplier::ApplicationController
  before_action :set_auction_promotion_activity_apply_product, only: [ :edit, :update, :destroy]

  def index
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.all
  end

  def show
    auction_promotion_activity_apply = Auction::PromotionActivityApply.where(:status => 3, :promotion_activity_id => params[:id]).active
    params[:q][:promotion_activity_apply_id_in] = auction_promotion_activity_apply.map{|item| item.id}
    @auction_promotion_activity_apply_products = Auction::PromotionActivityApplyProduct.active.where(:promotion_activity_id => params[:id]).ransack(params[:q]).result.includes(:product, :provider).page(params[:page]).per(15)
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
