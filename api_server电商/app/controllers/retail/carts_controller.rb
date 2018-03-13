class Retail::CartsController < ApplicationController
  # before_action :set_retail_cart, only: [:show, :edit, :update, :destroy]

  # 购物车商品列表
  #
  # GET /retail/carts
  # @param [integer]  page 页码
  # @param [integer]  page_size 每页数量
  # @return ({data:{retail_carts: Array<Retail::Cart>}, status: 200})
  # @author zhixin <zhixin.he@ihaveu.net>
  def index
    Rails.logger.info('????????????????????'+current_user.inspect)
    if params[:page].blank? || params[:page].to_i <= 0
      return render json: {status: 500, msg: "参数错误", data:{}}
    end
    begin
      if current_user.present?
        # 通
        res = Retail::Cart.carts({'userId': current_user['id'], 'pageNo': params[:page].to_i, 'pageSize': params[:page_size].to_i})
        # res = Retail::Cart.carts({'userId': 40116})
        # res = Retail::Cart.carts({'userId': 42210})
          # res = Retail::Cart.carts({'userId': 1})
        Rails.logger.info('------------------')
      else
        # 通
        res = Retail::Cart.carts({'sessionKey': session.id, 'pageNo': params[:page].to_i, 'pageSize': params[:page_size].to_i })
        # res = Retail::Cart.carts({'sessionKey': 'testaa001' })
        Rails.logger.info('+++++++++++++++'+session&.id.to_s)
      end

      if res[:comm][:code] == "200"
        return render json: {status: 200, msg: "成功", data: {retail_carts: res[:data]}}
      end

      return render json: {status: 500, msg: "失败1", data:{ }}
    rescue Exception => e
      return render json: {status: 500, msg: "失败2", data:{}}
    end
  end

  # 添加商品
  # POST /retail/carts
  # @param [integer] retail_cart[product_id] 商品id
  # @param [integer]  retail_cart[sku_id] 尺寸
  # @param [string]  retail_cart[client] 客户端类型
  #
  # @return ({status: 200/500})
  # @author zhixin <zhixin.he@ihaveu.net>
  def create
    Rails.logger.info('????????????????????'+current_user.inspect)
    if params[:retail_cart][:sku_id].blank? || params[:retail_cart][:product_id].blank? || params[:retail_cart][:client].blank? || params[:retail_cart][:sku_id].to_i <= 0
      return render json: {status: 500, msg: "添加商品失败，参数错误", data:{}}
    end
    begin
      if current_user.present?
        # 通
        res = Retail::Cart.insertCarts('userId': current_user['id'], 'productId': params[:retail_cart][:product_id].to_i, 'skuId': params[:retail_cart][:sku_id].to_i, 'client': params[:retail_cart][:client])
        Rails.logger.info('------------------')
        # res = Retail::Cart.insertCarts('userId': 40116, 'productId': 40322114, 'skuId': 107563, 'client': 'ios')
      elsif session.id
        # 通
        res = Retail::Cart.insertCarts('sessionKey': session.id, 'productId': params[:retail_cart][:product_id].to_i, 'skuId': params[:retail_cart][:sku_id].to_i, 'client': params[:retail_cart][:client])
        Rails.logger.info('++++++++++++++++----')
        # res = Retail::Cart.insertCarts('sessionKey': 'testaa001', 'productId': 40322114, 'skuId': 107563, 'client': 'ios')
      end

      if res[:comm][:code] == "200"
        return render json: {status: 200, msg: "添加商品成功", data:{retail_cart: res[:data]}}
      end
      return render json: {status: 500, msg: "#{res[:comm][:msg]}", data:{}}
    rescue Exception => e
      return render json: {status: 500, msg: "添加商品失败1", data:{}}
    end
  end


  # 删除商品
  # DELETE /retail/carts/1
  # @param ids [array] 购物车id数组
  #
  # @return ({status: 200/500})
  # @author zhixin <zhixin.he@ihaveu.net>
  def destroy
    if params[:ids].blank?
      return render json: {status: 500, msg: "删除失败", data:{}}
    end
    begin
      if current_user.present?
        # 通
        res = Retail::Cart.deleteCarts('userId': current_user['id'], 'cartId': params[:ids])
        # res = Retail::Cart.deleteCarts('userId': 42275, 'cartId': '6737')
        # res = Retail::Cart.deleteCarts('userId': 42275, 'cartId': '6737,6738')
      elsif session.id
        # 通
        res = Retail::Cart.deleteCarts('sessionKey': session.id, 'cartId': params[:ids])
        # res = Retail::Cart.deleteCarts('sessionKey': 'f35556bc1dcd628e9be824186f82ffb8', 'cartId': '15,16,17')
      end

      if res[:comm][:code] == "200"
        return render json: {status: 200, msg: "删除成功", data:{ }}
      end
      return render json: {status: 500, msg: '删除失败', data: {}}
    rescue Exception => e
      return render json: {status: 500, msg: "删除失败1", data:{}}
    end
  end

  # def options
  #   render json: {data: {data: Retail::Cart.options}, status: 200, msg: 200}
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retail_cart
      @retail_cart = Retail::Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retail_cart_params
      # params.fetch(:retail_cart, {})
      params.require(:retail_cart).permit!
    end
end
