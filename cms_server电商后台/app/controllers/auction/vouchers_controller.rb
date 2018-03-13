class Auction::VouchersController < ApplicationController
  before_action :set_auction_voucher, only: [:show, :edit, :update, :destroy]
  before_action :side_menus4

  # GET /auction/vouchers
  # GET /auction/vouchers.json
  def index
    @bread_menu = {m1: '优惠券管理', m2: '优惠券管理', m2_url: '/auction/vouchers', add: '/auction/vouchers/new', s: 'voucher_search'}
    @auction_vouchers = Auction::Voucher.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/vouchers/1
  # GET /auction/vouchers/1.json
  def show
  end

  # GET /auction/vouchers/new
  def new
    @bread_menu = {m1: '优惠券管理', m2: '优惠券管理', m2_url: '/auction/vouchers', m3: '发放优惠券'}
    @auction_voucher = Auction::Voucher.new
  end

  # GET /auction/vouchers/1/edit
  def edit
  end

  # POST /auction/vouchers
  # POST /auction/vouchers.json
  def create
    auction_voucher = Auction::Event.find_by(id: auction_voucher_params[:event_id])
    if auction_voucher && auction_voucher.ended_at > Time.now && auction_voucher.published == true
      ActiveRecord::Base.transaction do
        if auction_voucher_params[:user_id].split(",").length > 1
          auction_voucher_params[:user_id].split(",").each do |id|
            @auction_voucher = Auction::Voucher.create(:user_id => id,:event_id => auction_voucher_params[:event_id] ,:obtained_at => Time.now)
          end
        else
          @auction_voucher = Auction::Voucher.create(:user_id => auction_voucher_params[:user_id],:event_id => auction_voucher_params[:event_id] ,:obtained_at => Time.now)
        end
      end
      if @auction_voucher
        flash_msg('success', "发放优惠券成功", 'index')
      else
        flash_msg('danger', "发放优惠券失败", 'new')
      end
    else
      flash_msg('danger', "发放优惠券失败！id 为#{auction_voucher_params[:event_id]}的券种不存在,或已过期,或未发布", 'new')
    end
  end

  # PATCH/PUT /auction/vouchers/1
  # PATCH/PUT /auction/vouchers/1.json
  def update
    if @auction_voucher.update(auction_voucher_params)
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/auction/vouchers'
  end

  # DELETE /auction/vouchers/1
  # DELETE /auction/vouchers/1.json
  def destroy
    @auction_voucher.destroy
    respond_to do |format|
      format.html { redirect_to auction_vouchers_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_voucher
      @auction_voucher = Auction::Voucher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_voucher_params
      # params.fetch(:auction_voucher, {})
      params.require(:auction_voucher).permit!
    end
end
