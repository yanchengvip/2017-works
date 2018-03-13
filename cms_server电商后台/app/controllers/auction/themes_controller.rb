class Auction::ThemesController < ApplicationController
  before_action :set_auction_theme, only: [:show, :edit, :update, :destroy, :up_move, :down_move, :up_status, :down_status]
  before_action :side_menus1

  def index
    params[:q][:s] = "rank desc"
    @bread_menu = {m1: '内容管理', m2: '专题管理', m2_url: '/auction/themes', m3: '专题列表', add: '/auction/themes/new', s: 'themes_search'}
    @q = Auction::Theme.ransack(params[:q])
    @auction_themes = @q.result.page(params[:page]).per(15)
  end

  def show
    @bread_menu = {m1: '专题管理', m2: '专题管理', m2_url: '/auction/themes', m3: '专题详情'}
  end

  def new
    @bread_menu = {m1: '专题管理', m2: '专题管理', m2_url: '/auction/themes', m3: '新增专题'}
    @auction_theme = Auction::Theme.new(down_time: Time.now + 365 * 3600 * 24, publish_time: Date.today + 1)
  end

  def edit
    @bread_menu = {m1: '专题管理', m2: '专题管理', m2_url: '/auction/themes', m3: '修改专题'}
  end

  def create
    auction_theme = Auction::Theme.new(auction_theme_params)
    ats = Auction::Theme.where(rank: auction_theme.rank)

    unless ats.blank?
      flash['danger'] = "添加专题失败，排序不能重复！"
      @auction_theme = auction_theme
      @type = 'new'
      return render action: :new
    end

    begin
      if auction_theme.save!
        flash['success'] = "添加专题成功！"
        return redirect_to action: :index
      end
    rescue Exception => e
      flash['danger'] = "添加专题失败！#{error_msg(auction_theme)}"
      @auction_theme = auction_theme
      return render action: :new
    end
  end

  def update
    ats = Auction::Theme.where(rank: auction_theme_params[:rank]).where.not(id: @auction_theme.id)
    unless ats.blank?
      flash['danger'] = "修改专题失败，排序不能重复！"
      return redirect_to action: 'edit', id: @auction_theme.id
    end

    begin
      if @auction_theme.update_attributes!(auction_theme_params)
        flash_msg('success', '修改专题成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改专题失败！#{error_msg(@auction_theme)}'
      return redict_to action: 'edit', id: @auction_theme.id
    end
  end

  def up_move
    begin
      theme = Auction::Theme.where("rank > ?", @auction_theme.rank).order(rank: :asc).first
      origin_rank = @auction_theme.rank
      if @auction_theme.update_attributes!(rank: theme.rank) && theme.update_attributes!(rank: origin_rank)
        flash[:success] = '上移成功'
      end
    rescue Exception => e
      flash[:danger] = '上移失败，排序已在最上'
    end

    redirect_to '/auction/themes'
  end

  def down_move
    begin
      theme = Auction::Theme.where("rank < ?", @auction_theme.rank).order(rank: :desc).first
      origin_rank = @auction_theme.rank
      if @auction_theme.update_attributes!(rank: theme.rank) && theme.update_attributes!(rank: origin_rank)
        flash[:success] = '下移成功'
      end
    rescue Exception => e
      flash[:danger] = '下移失败，排序已在最下'
    end

    redirect_to '/auction/themes'
  end

  def up_status
    if @auction_theme.down_time < Time.now
      flash[:danger] = '上线失败,该专题已下线'
    else
      if @auction_theme.update_attributes!(:published => true,:publish_time => Time.now)
        flash[:success] = '上线成功'
      else
        flash[:danger] = '上线失败'
      end
    end
    redirect_to '/auction/themes'
  end

  def down_status
    if @auction_theme.update_attributes!(:published => false,:down_time => Time.now)
      flash[:success] = '下线成功'
    else
      flash[:danger] = '下线失败'
    end
    redirect_to '/auction/themes'
  end

  def destroy
    @auction_theme.destroy
    respond_to do |format|
      format.html { redirect_to auction_themes_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_auction_theme
      @auction_theme = Auction::Theme.find(params[:id]) if params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_theme_params
      params.require(:auction_theme).permit(:title, :subtitle, :pic, :publish_time, :down_time, :published, :keyword, :brand_id, :target, :unsold_count, :category1_id, :category2_id, :category3_id, :sort_key, :sort_method, :price_gt, :price_lt, :theme_type, :rank, :link_url)
    end
end
