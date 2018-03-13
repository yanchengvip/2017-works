class Auction::SmsController < ApplicationController
  before_action :set_auction_sm, only: [:show, :edit, :update, :destroy, :send_sms]
  before_action :side_menus4

  # GET /auction/sms
  # GET /auction/sms.json
  def index
    @bread_menu = {m1: '短信管理', m2: '短信管理', m2_url: '/auction/sms', add: '/auction/sms/new', s: 'sms_search'}
    @auction_sms = Auction::Sm.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/sms/1
  # GET /auction/sms/1.json
  def show
  end

  # GET /auction/sms/new
  def new
    @bread_menu = {m1: '短信管理', m2: '短信管理', m2_url: '/auction/sms', add: '/auction/sms/new', s: 'sms_search'}
    @auction_sm = Auction::Sm.new
  end

  # GET /auction/sms/1/edit
  def edit
  end

  # POST /auction/sms
  # POST /auction/sms.json
  def create
    if auction_sm_params[:phone].split(",").length > 1
      auction_sm_params[:phone].split(",").each do |p|
        @auction_sm = Auction::Sm.create(phone: p, content: auction_sm_params[:content])
      end
    else
      @auction_sm = Auction::Sm.create(phone: auction_sm_params[:phone], content: auction_sm_params[:content])
    end
    if @auction_sm
      flash[:success] = '创建成功'
    else
      flash[:error] = '创建失败'
    end
    redirect_to '/auction/sms'

  end
  #发送短信
  def send_sms
    if @auction_sm.send_by
      flash[:success] = '发送成功'
    else
      flash[:error] = '发送失败'
    end
    redirect_to '/auction/sms'
  end

  # PATCH/PUT /auction/sms/1
  # PATCH/PUT /auction/sms/1.json
  def update
    if @auction_sm.update(auction_sm_params)
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/auction/sms'
  end

  # DELETE /auction/sms/1
  # DELETE /auction/sms/1.json
  def destroy
    if @auction_sm.destroy
      flash[:success] = '删除成功'
    end
    redirect_to '/auction/sms'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_sm
      @auction_sm = Auction::Sm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_sm_params
      params.require(:auction_sm).permit!
      # params.fetch(:auction_sm, {})
    end
end
