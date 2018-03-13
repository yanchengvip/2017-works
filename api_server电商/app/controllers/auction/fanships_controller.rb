class Auction::FanshipsController < ApplicationController
  before_action :set_auction_fanship, only: [:show, :edit, :update]


  #  品牌收藏列表
  #
  # GET /auction/fanships
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  # @param user_id [integer] 用户id
  #
  # @return ({data:{auction_fanships: Array<Auction::Fanship>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    fanship = {
      'userId': current_user[:id],
      'pageSize': params[:per_page].to_i,
      'pageNo': params[:page].to_i
    }
   fanship = Auction::Fanship.list fanship
   if fanship[:comm][:code] == "200"
     render json: {status: fanship[:comm][:code].to_i, msg: fanship[:comm][:msg], data: {auction_fanships: fanship[:data]}}
   else
     render json: {status: fanship[:comm][:code].to_i, msg: fanship[:comm][:msg], data: {}}
   end

  end


  # 添加品牌收藏
  # POST /auction/fanships
  # @param [Hash] auction_fanship 收货地址
  # @param [string] fanship[brand_id]  品牌id
  # @param [string] fanship[lock_version]
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def create
      fanship = {
          user_id: current_user[:id],
          brand_id: params[:brand_id].to_i
      }
    fanship = Auction::Fanship.insert fanship
    render json: {status: fanship[:comm][:code].to_i, msg: fanship[:comm][:msg], data: {auction_fanships: fanship[:data]}}
  end


  #删除收货地址接口
  # DELETE /auction/fanships/1
  # @param id [integer] id
  #
  # @return ({status: 200/500})
  # @author wangxia <xia.wang01@ihaveu.net>
  def destroy
    fanship = {
          user_id: current_user[:id],
          brand_id: params[:id].to_i
      }
    fanship = Auction::Fanship.delete fanship
    render json: {status: fanship[:comm][:code].to_i, msg: fanship[:comm][:msg], data: {auction_fanships: fanship[:data]}}
  end
  #是否已经被收藏了/auction/fanships/:id/is_collect
  def is_collect
    fanship = {
          user_id: current_user[:id],
          brand_id: params[:id].to_i
      }
    fanship = Auction::Fanship.isBrandCollect fanship
    render json: {status: fanship[:comm][:code].to_i, msg: fanship[:comm][:msg], data: {data: fanship[:data]}}
  end

end
