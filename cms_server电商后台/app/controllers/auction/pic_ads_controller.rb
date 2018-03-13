class Auction::PicAdsController < ApplicationController
  before_action :set_auction_pic_ad, only: [:show, :edit, :update, :destroy, :up_move, :down_move, :up_status, :down_status]
  before_action :side_menus1

  def index
    params[:q][:s] = "sort_field desc"
    @bread_menu = {m1: '内容管理', m2: '轮播管理', m2_url: '/auction/pic_ads', m3: '轮播列表', add: '/auction/pic_ads/new', s: 'pic_ads_search'}
    @q = Auction::PicAd.active.ransack(params[:q])
    @auction_pic_ads = @q.result.page(params[:page]).per(15)
  end

  def show
    @bread_menu = {m1: '轮播管理', m2: '轮播管理', m2_url: '/auction/pic_ads', m3: '轮播详情'}
  end

  def new
    @bread_menu = {m1: '轮播管理', m2: '轮播管理', m2_url: '/auction/pic_ads', m3: '新增轮播'}
    @auction_pic_ad = Auction::PicAd.new(down_time: Time.now.strftime('%Y-%m-%d %H:%M:%S'), publish_time: Date.today + 1)
  end

  def edit
    @bread_menu = {m1: '轮播管理', m2: '轮播管理', m2_url: '/auction/pic_ads', m3: '修改轮播'}
  end

  def create
    auction_pic_ad = Auction::PicAd.new(auction_pic_ad_params)
    pads = Auction::PicAd.where(sort_field: auction_pic_ad.sort_field)
    unless pads.blank?
      flash['danger'] = "添加轮播失败，排序不能重复！"
      @auction_pic_ad = auction_pic_ad
      return render action: 'new'
    end

    begin
      if auction_pic_ad.save!
        flash['success'] = "添加轮播成功！"
        return redirect_to action: 'index'
      end
    rescue Exception => e
      flash['danger'] = "添加轮播失败！#{error_msg(auction_pic_ad)}"
      @auction_pic_ad = auction_pic_ad
      return render action: 'new'
    end
  end

  def update
    pads = Auction::PicAd.where(sort_field: auction_pic_ad_params[:sort_field]).where.not(id: @auction_pic_ad.id)
    unless pads.blank?
      flash['danger'] = "修改轮播失败，排序不能重复！"
      return redirect_to action: 'edit', id: @auction_pic_ad.id
    end

    begin
      if @auction_pic_ad.update_attributes!(auction_pic_ad_params)
        flash['success'] = "修改轮播成功！"
        return redirect_to action: 'index'
      end
    rescue Exception => e
      flash['danger'] = "修改轮播失败！#{error_msg(@auction_pic_ad)}"
      return redirect_to action: 'edit', id: @auction_pic_ad.id
    end
  end

  def up_move
    begin
      pic = Auction::PicAd.where("sort_field > ?", @auction_pic_ad.sort_field).order(sort_field: :asc).first
      origin_sort_field = @auction_pic_ad.sort_field
      if @auction_pic_ad.update_attributes!(sort_field: pic.sort_field) && pic.update_attributes!(sort_field: origin_sort_field)
        flash[:success] = '上移成功'
      end
    rescue Exception => e
      flash[:danger] = '上移失败，排序已在最上'
    end

    redirect_to '/auction/pic_ads'
  end

  def down_move
    begin
      pic = Auction::PicAd.where("sort_field < ?", @auction_pic_ad.sort_field).order(sort_field: :desc).first
      origin_sort_field = @auction_pic_ad.sort_field
      if @auction_pic_ad.update_attributes!(sort_field: pic.sort_field) && pic.update_attributes!(sort_field: origin_sort_field)
        flash[:success] = '下移成功'
      end
    rescue Exception => e
      flash[:danger] = '下移失败，排序已在最下'
    end

    redirect_to '/auction/pic_ads'
  end

  def up_status
    if @auction_pic_ad.down_time < Time.now
      flash[:danger] = '上线失败,该轮播图已过期'
    else
      if @auction_pic_ad.update_attributes!(:published => true,:publish_time => Time.now)
        flash[:success] = '上线成功'
      else
        flash[:danger] = '上线失败'
      end
    end
    redirect_to '/auction/pic_ads'
  end

  def down_status
    if @auction_pic_ad.update_attributes!(:published => false, :down_time => Time.now)
      flash[:success] = '下线成功'
    else
      flash[:danger] = '下线失败'
    end
    redirect_to '/auction/pic_ads'
  end

  def destroy
    @auction_pic_ad.destroy
    respond_to do |format|
      format.html { redirect_to auction_pic_ads_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_auction_pic_ad
      @auction_pic_ad = Auction::PicAd.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_pic_ad_params
      params.require(:auction_pic_ad).permit!
    end
end
