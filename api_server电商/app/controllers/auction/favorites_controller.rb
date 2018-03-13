class Auction::FavoritesController < ApplicationController

  #  商品收藏列表
  #
  # GET /auction/favorites
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  # @param user_id [integer] 用户id
  #
  # @return ({data:{auction_favorites: Array<Auction::Favorite>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
      favorite = {
        'userId': current_user[:id],
        'pageSize': params[:per_page].to_i,
        'pageNo': params[:page].to_i
      }
     favorite = Auction::Favorite.list favorite
     if favorite[:comm][:code] == "200"
       render json: {status: favorite[:comm][:code].to_i, msg: favorite[:comm][:msg], data: {auction_favorites: favorite[:data]}}
     else
       render json: {status: favorite[:comm][:code].to_i, msg: favorite[:comm][:msg], data: {}}
     end
  end


  # 添加商品收藏
  # POST /auction/favorites
  # @param [Hash] auction_favorite 商品收藏
  # @param [string] favorite[product_id]  商品id
  # @param [string] favorite[lock_version]
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
    favorite = {
      user_id: current_user[:id],
      product_id: params[:product_id].to_i
    }
    favorite = Auction::Favorite.insert favorite
    render json: {status: favorite[:comm][:code].to_i, msg: favorite[:comm][:msg], data: {auction_favorites: favorite[:data]}}
  end


  # 删除商品收藏
  # DELETE /auction/favorites/1
  # @param id [integer] id
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy
    favorite = {
      user_id: current_user[:id],
      product_id: params[:id].to_i
    }
    favorite = Auction::Favorite.delete favorite
    render json: {status: favorite[:comm][:code].to_i, msg: favorite[:comm][:msg], data: {auction_favorites: favorite[:data]}}
  end
  #是否已经被收藏了/auction/favorites/:id/is_collect
  def is_collect
    favorite = {
      user_id: current_user[:id],
      product_id: params[:id].to_i
    }
    favorite = Auction::Favorite.isProductCollect favorite
    render json: {status:favorite[:comm][:code].to_i, msg: favorite[:comm][:msg], data: {data: favorite[:data]}}
  end

end
