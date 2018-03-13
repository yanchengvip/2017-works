class Auction::VouchersController < ApplicationController


  #  个人优惠券列表
  #
  # GET /auction/vouchers
  # @param page [integer] 分页数, default: 1
  # @param per_page [integer] 每页显示, default: 10
  #
  # @return ({data:{auction_vouchers: Array<Auction::Voucher>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def index
    voucher = {
      "userId": current_user[:id],
      "pageNo": params[:page].to_i,
      "pageSize": params[:per_page].to_i
    }
    vouchers = Auction::Voucher.vouchers voucher
    render json: {status: vouchers[:comm][:code].to_i, msg: vouchers[:comm][:msg], data: {auction_vouchers: vouchers[:data][:auction_vouchers],total: vouchers[:data][:total], count: vouchers[:data][:auction_vouchers].count || 0}}
  end


  # PATCH/PUT /auction/vouchers/1
  # PATCH/PUT /auction/vouchers/1.json
  # 兑换优惠券
  # @param [string] voucher[identifier]  兑换码
  #
  # @return ({data:{auction_vouchers: Array<Auction::Voucher>}, status: 200})
  # @author wangxia <xia.wang01@ihaveu.net>
  def update
    params[:voucher].merge!(user_id: current_user[:id])
    vouchers = Auction::Voucher.updatevouchers params
    render json: {status: vouchers[:comm][:code].to_i, msg: vouchers[:comm][:msg], data: {}}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_voucher
      @auction_voucher = Auction::Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_voucher_params
      params.fetch(:auction_voucher, {})
    end
end
