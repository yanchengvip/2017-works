class Auction::BrandsController < ApplicationController
  before_action :set_auction_brand, only: [:show, :edit, :update, :destroy]
  before_action :side_menus2

  # GET /manage/categories
  # GET /manage/categories.json
  def index
    @bread_menu = {m1: '品牌管理', m2: '品牌管理', m2_url: '/auction/brands', m3: '品牌列表', add: '/auction/brands/new', s: 'brands_search'}
    @q = Auction::Brand.ransack(params[:q])
    @manage_brands = @q.result.page(params[:page]).per(15)
  end

  # GET /manage/categories/1
  # GET /manage/categories/1.json
  def show
    @bread_menu = {m1: '品牌管理', m2: '品牌管理', m2_url: '/auction/brands', m3: '品牌详情'}
  end

  # GET /manage/categories/new
  def new
    @bread_menu = {m1: '品牌管理', m2: '品牌管理', m2_url: '/auction/brands', m3: '新增品牌'}
    @auction_brand = Auction::Brand.new
  end

  # GET /manage/categories/1/edit
  def edit
    @bread_menu = {m1: '品牌管理', m2: '品牌管理', m2_url: '/auction/brands', m3: '修改品牌'}
  end

  # POST /manage/categories
  # POST /manage/categories.json
  def create
    auction_brand = Auction::Brand.new(auction_brand_params)

    begin
      if auction_brand.save!
        flash_msg('success', '添加品牌成功！', 'index')
      end
    rescue Exception => e
      flash_render('danger', "添加品牌失败！#{error_msg(auction_brand)}", 'new')
    end
  end

  # PATCH/PUT /manage/categories/1
  # PATCH/PUT /manage/categories/1.json
  def update
    begin
      if @auction_brand.update_attributes!(auction_brand_params)
        flash_msg('success', '修改品牌成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改品牌失败！#{error_msg(@auction_brand)}'
      return redict_to action: 'edit', id: @auction_brand.id
    end
  end

  # DELETE /manage/categories/1
  # DELETE /manage/categories/1.json
  def destroy
    @auction_brand.destroy
    respond_to do |format|
      format.html { redirect_to auction_brands_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  def set_auction_brand
    @auction_brand = Auction::Brand.find(params[:id]) if params[:id]
  end

  def auction_brand_params
    # params.fetch(:auction_brand, {})
    params.require(:auction_brand).permit!
  end

end
