class Auction::BrandsController < ApplicationController

  # GET /auction/brands
  # GET /auction/brands.json
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_brands: Array<Auction::Brand>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    brand = {
      "pageNo": params[:page].to_i,
      "pageSize": params[:per_page].to_i
    }
    auction_brands = Auction::Brand.list brand
    render json: {status: auction_brands[:comm][:code].to_i, msg: auction_brands[:comm][:msg], data: {auction_brands: auction_brands[:data].as_json(Auction::Brand.xml_options) }}
  end

  def show
    brand = {
      "brandsId": params[:id].to_i
    }
    auction_brands = Auction::Brand.detail brand
    render json: {status: auction_brands[:comm][:code].to_i, msg: auction_brands[:comm][:msg], data: {auction_brands: auction_brands[:data].slice_as_json(Auction::Brand.showxml_options)}}
  end
  #根据id数据查询
  def show_by_ids
    ids = {
      "brandsIds": params[:ids]
    }
    auction_brands = Auction::Brand.detail_ids ids
    render json: {status: auction_brands[:comm][:code].to_i, msg: auction_brands[:comm][:msg], data: {auction_brands: auction_brands[:data]}}
  end

end
