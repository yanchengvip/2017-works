class Auction::SeckillsController < ApplicationController
  before_action :set_auction_seckill, only: [:show, :edit, :update, :destroy]
  before_action :side_menus4

  def index
    @bread_menu = {m1: '运营管理', m2: '秒杀管理', m2_url: '/auction/seckills', m3: '秒杀列表', add: '/auction/seckills/new', s: 'seckills_search'}
    @q = Auction::Seckill.ransack(params[:q])

    if params[:history]
      @auction_seckills = @q.result.where("date < ?", Date.today).includes(:product).page(params[:page]).per(15)
    else
      params[:play] ||= 1
      @auction_seckills = @q.result.where("play = ? and date >= ?", params[:play], Date.today).includes(:product).page(params[:page]).per(15)
    end
  end

  def show
    @bread_menu = {m1: '秒杀管理', m2: '秒杀管理', m2_url: '/auction/seckills', m3: '秒杀详情'}
  end

  def new
    @bread_menu = {m1: '秒杀管理', m2: '秒杀管理', m2_url: '/auction/seckills', m3: '新增秒杀'}
    @auction_seckill = Auction::Seckill.new
    # (date: Time.now.strftime("%Y-%m-%d %H:%m:%S"))
  end

  def edit
    @bread_menu = {m1: '秒杀管理', m2: '秒杀管理', m2_url: '/auction/seckills', m3: '修改秒杀'}
  end

  def create
    auction_product = Auction::Product.find_by(id: auction_seckill_params[:product_id])

    auction_seckill = Auction::Seckill.find_by(product_id: auction_seckill_params[:product_id], play: auction_seckill_params[:play], date: auction_seckill_params[:date])

    if auction_product && auction_product.published == true && auction_seckill.blank?
      auction_seckill = Auction::Seckill.new(auction_seckill_params)
      begin
        if auction_seckill.save!
          flash_msg('success', '添加秒杀成功！', 'index')
        end
      rescue Exception => e
        flash_msg('danger', "添加秒杀失败！#{error_msg(auction_seckill)}", 'new')
      end
    else
      flash[:danger] = '添加失败，该商品不存在或已下架.或该商品已存在该场次'
      return redirect_to action: :new
    end

  end

  def update
    auction_product = Auction::Product.find_by(id: auction_seckill_params[:product_id])

    if auction_product && auction_product.published == true
      begin
        if @auction_seckill.update_attributes!(auction_seckill_params)
          flash_msg('success', '修改秒杀成功！', 'index')
        end
      rescue Exception => e
        flash['danger'] = '修改秒杀失败！#{error_msg(@auction_seckill)}'
        return redict_to action: 'edit', id: @auction_seckill.id
      end
    else
      flash[:danger] = '修改失败，该商品不存在或已下架'
      return redirect_to action: :edit, id: @auction_seckill.id
    end

  end

  def destroy
    @auction_seckill.destroy
    respond_to do |format|
      format.html { redirect_to auction_seckills_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_auction_seckill
      @auction_seckill = Auction::Seckill.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_seckill_params
      params.require(:auction_seckill).permit(:product_id, :discount, :date, :play, :active, :user_id)
    end
end
