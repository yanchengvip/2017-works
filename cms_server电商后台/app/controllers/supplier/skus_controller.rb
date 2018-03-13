class Supplier::SkusController < Supplier::ApplicationController
  before_action :set_supplier_sku, only: [ :edit, :update, :destroy]
  def index
    @skus = Auction::Sku.includes(:supplier_product).active.where("provider_id" => current_user.id).ransack(params[:q]).result.order(product_id: :desc, id: :desc).page(params[:page] || 1)
  end

  def edit
    @sku = Auction::Sku.active.find(params[:id])
  end


  def update
    respond_to do |format|
      if @sku.update(supplier_sku_params)
        format.html { redirect_to "/supplier/skus", flash:{success: '更新成功'} }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @sku.destroy
    respond_to do |format|
      format.html { redirect_to "/supplier/skus", flash:{success: '删除成功'} }
    end
  end

  private
  def set_supplier_sku
    @sku = Auction::Sku.active.where(id: params[:id], provider_id: current_user.id).first
  end

  def supplier_sku_params
    params.require(:auction_sku).permit( :name, :amount, :code, :product_id, :provider_id)
  end

end
