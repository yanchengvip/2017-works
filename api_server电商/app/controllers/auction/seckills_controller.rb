class Auction::SeckillsController < ApplicationController

  #  秒杀列表
  #
  # GET /auction/seckills
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_seckills: Array<Auction::Seckill>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    # render json: {status: 200, msg: "成功", data: {   "auction_seckills": [
    #         {
    #             "product_id": 1,
    #             "discount": 12,
    #             "play": 1,
    #             "date": "2017-01-01 00:00:00",
    #             "user_id": 1,
    #             "product":[{
    #               "name": "品牌名"
    #               }]
    #         }
    #     ] }} and return
    auction_seckills =  Auction::Seckill.where("date = ? and active = true", Date.today.to_s)
    render json:{status:  200,  msg: "成功", data: {auction_seckills: auction_seckills}}
  end

end
