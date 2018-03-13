class Auction::AttributesController < ApplicationController
  before_action :set_auction_attribute, only: [:show, :edit, :update, :destroy]
  before_action :side_menus2

  # GET /manage/attributes
  # GET /manage/attributes.json
  def index
    @bread_menu = {m1: '属性管理', m2: '属性管理', m2_url: '/auction/attributes', m3: '属性列表', add: '/auction/attributes/new', s: 'attributes_search'}
    @q = Auction::ProductAttribute.ransack(params[:q])
    @manage_attributes = @q.result.includes(:editor).page(params[:page]).per(15)
  end

  # GET /manage/attributes/1
  # GET /manage/attributes/1.json
  def show
    @bread_menu = {m1: '属性管理', m2: '属性管理', m2_url: '/auction/attributes', m3: '属性详情'}
  end

  # GET /manage/attributes/new
  def new
    @bread_menu = {m1: '属性管理', m2: '属性管理', m2_url: '/auction/attributes', m3: '新增属性'}
    @auction_attribute = Auction::ProductAttribute.new
  end

  # GET /manage/attributes/1/edit
  def edit
    @bread_menu = {m1: '属性管理', m2: '属性管理', m2_url: '/auction/attributes', m3: '修改属性'}
  end

  # POST /manage/attributes
  # POST /manage/attributes.json
  def create
    auction_attribute = Auction::ProductAttribute.new(auction_attribute_params)

    begin
      if auction_attribute.save!
        flash_msg('success', '添加属性成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = "添加属性失败！#{error_msg(auction_attribute)}"
      return redirect_to action: 'new'
      # flash_render('danger', "添加属性失败！#{error_msg(auction_attribute)}", 'new')
    end
  end

  # PATCH/PUT /manage/attributes/1
  # PATCH/PUT /manage/attributes/1.json
  def update
    begin
      if @auction_attribute.update_attributes!(auction_attribute_params)
        flash_msg('success', '修改属性成功！', 'index')
      end
    rescue Exception => e
      flash['danger'] = '修改属性失败！#{error_msg(@auction_attribute)}'
      return redirect_to action: 'edit', id: @auction_attribute.id
    end
  end

  # DELETE /manage/attributes/1
  # DELETE /manage/attributes/1.json
  def destroy
    @auction_attribute.destroy
    respond_to do |format|
      format.html { redirect_to auction_attributes_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  def set_auction_attribute
    @auction_attribute = Auction::ProductAttribute.find(params[:id]) if params[:id]
  end

  def auction_attribute_params
    # params.fetch(:auction_attribute, {})
    params.require(:auction_product_attribute).permit!
  end

end
