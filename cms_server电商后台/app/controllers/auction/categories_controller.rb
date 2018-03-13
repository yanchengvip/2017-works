class Auction::CategoriesController < ApplicationController
  before_action :set_auction_category, only: [:show, :edit, :update, :destroy]
  before_action :side_menus2

  # GET /manage/categories
  # GET /manage/categories.json
  def index
    @bread_menu = {m1: '分类管理', m2: '分类管理', m2_url: '/auction/categories', m3: '分类列表',add: '/auction/categories/new', s: 'categories_search'}
    @q = Auction::Category.ransack(params[:q])
    @manage_categories = @q.result.page(params[:page]).per(15)
  end

  # GET /manage/categories/1
  # GET /manage/categories/1.json
  def show
    @bread_menu = {m1: '分类管理', m2: '分类管理', m2_url: '/auction/categories', m3: '分类详情'}
  end

  # GET /manage/categories/new
  def new
    @bread_menu = {m1: '分类管理', m2: '分类管理', m2_url: '/auction/categories/new', m3: '新增分类'}
    @auction_category = Auction::Category.new
  end

  # GET /manage/categories/1/edit
  def edit
    @bread_menu = {m1: '分类管理', m2: '分类管理', m2_url: '/auction/categories/edit', m3: '修改分类'}
  end

  # POST /manage/categories
  # POST /manage/categories.json
  def create
    auction_category = Auction::Category.new(auction_category_params)

    begin
      if auction_category.save_category!(params[:auction_category][:attribute_ids])
        flash_msg('success', '添加分类成功！', 'index')
      end
    rescue Exception => e
      flash_render('danger', "添加分类失败！#{error_msg(auction_category)}", 'new')
    end
  end

  # PATCH/PUT /manage/categories/1
  # PATCH/PUT /manage/categories/1.json
  def update
    begin
      if @auction_category.update_category!(auction_category_params, params[:auction_category][:attribute_ids])
        flash_msg('success', '修改分类成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改分类失败！#{error_msg(@auction_category)}'
      return redict_to action: 'edit', id: @auction_category.id
    end
  end

  # DELETE /manage/categories/1
  # DELETE /manage/categories/1.json
  def destroy
    @auction_category.destroy
    respond_to do |format|
      format.html { redirect_to auction_categorys_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  def set_auction_category
    @auction_category = Auction::Category.find(params[:id]) if params[:id]
  end

  def auction_category_params
    # params.fetch(:auction_category, {})
    params.require(:auction_category).permit!
  end

end
