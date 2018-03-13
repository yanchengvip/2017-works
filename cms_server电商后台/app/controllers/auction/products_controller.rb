class Auction::ProductsController < ApplicationController
  before_action :set_supplier_product, except: [:index, :shelf, :change_discount, :edit, :update]
  before_action :set_auction_product, only: [:index, :shelf, :change_discount, :edit, :update]
  before_action :side_menus2
  skip_before_action :verify_authenticity_token, only: [:batch_update]


  # GET /auction/products
  # GET /auction/products.json
  def index
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品列表', s: 'products_search'}
    # @q ||= Auction::Product.includes(:skus, :category1, :category2, :category3, :brand)
    # @q = @q.where(id: params[:id_in].split(',')) if !params[:id_in].blank?
    # @q = @q.where("auction_skus.id": params[:skus_id_in].split(',')) if !params[:skus_id_in].blank?
    # @q = @q.ransack(params[:q])
    # @auction_products = @q.result.page(params[:page]).per(15)

    params[:q][:id_in] = params[:q][:id_in].split(",") if params[:q] && params[:q][:id_in] && params[:q][:id_in].is_a?(String)
    params[:q][:skus_id_in] = params[:q][:skus_id_in].split(",") if params[:q] && params[:q][:skus_id_in] && params[:q][:skus_id_in].is_a?(String)
    @q = Auction::Product.ransack(params[:q])
    @auction_products = @q.result.includes(:skus, :category1, :category2, :category3, :brand).page(params[:page]).per(15)
  end

  def show
    @skus = @supplier_product.skus
    @values = @supplier_product.values.group_by{|v| v.attribute_name}
    @images = @supplier_product.images.order(:sequence)
  end

  def edit
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品编辑'}
    # images = Auction::Image.get_image_url @auction_product
    # @img_paths = images[:img_paths]
    @supplier_product = @auction_product
    @images = @supplier_product.images.order(:sequence)
    @skus = @supplier_product.skus
    @attributes = @supplier_product.last_category&.own_attributes
    @values = @supplier_product.values.to_a
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        auction_product_params.extract!('provider_price', 'price', 'discount')
        if @auction_product.update_attributes!(auction_product_params.merge({spec_pic: params[:supplier_product][:spec_pic], color_pic: params[:supplier_product][:color_pic], major_pic: params[:supplier_product][:major_pic]}))
          # Auction::Image.change_image_url @auction_product, params[:image_urls], current_user.id
          @auction_product.save_images!(params['pimages'], current_user.id)
          @auction_product.update_values!(params[:input_category_attributes], params[:category_attributes], params[:attributes_names])
          flash[:success] = '修改商品成功！'
        end
      end
    rescue Exception => e
      flash[:danger] = "修改商品失败！#{error_msg(@auction_product)}"
    end

    return redirect_to action: :edit, id: @auction_product.id
  end

  def destroy
    @supplier_product.destroy
    respond_to do |format|
      format.html { redirect_to auction_products_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def item_form
    render partial: 'item_form'
  end

  def review
    begin
      if @supplier_product.update_attributes!(status: params[:review_status])
        flash_msg('success', '商品审核成功！', 'index')
      else
        flash['danger'] = '商品审核失败！#{error_msg(@supplier_product)}'
        return redict_to action: 'edit', id: @supplier_product.id
      end
    rescue Exception => e
      flash['danger'] = '商品审核失败！#{error_msg(@supplier_product)}'
      return redict_to action: 'edit', id: @supplier_product.id
    end
  end

  # 买手审核页面
  def ms_review_index
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品列表', s: 'ms_review_index_products_search'}
    @q = Supplier::Product.where(status: 1).ransack(params[:q])
    @supplier_products = @q.result.includes(:brand, :category1, :category2, :category3).page(params[:page]).per(15)
  end

  # 买手审核
  def ms_review
    unless params[:review_status].to_i.in? [0, 2]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    if @supplier_product.update_attribute(:status, params[:review_status])
      txt = params[:review_status].to_i == 0 ? '买手审核驳回' : '买手审核通过'
      create_review_log(@supplier_product, current_user.id, txt)
      return render json: {status: 200, msg: '审核通过', data: ''}
    end

    return render json: {status: 500, msg: "审核失败#{error_msg(@supplier_product)}", data: ''}
  end

  # 总监审核页面
  def zj_review_index
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品列表', s: 'zj_review_index_products_search'}
    @q = Supplier::Product.where(status: 2).ransack(params[:q])
    @supplier_products = @q.result.includes(:brand, :category1, :category2, :category3).page(params[:page]).per(15)
  end

  # 总监审核
  def zj_review
    unless params[:review_status].to_i&.in? [0, 3]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    if params[:review_status].to_i == 3 && @supplier_product.profit_margin >= Setting.warning_value
      params[:review_status] = 4
    end

    if @supplier_product.update_attribute(:status, params[:review_status])
      txt = params[:review_status].to_i == 0 ? '总监审核驳回' : '总监审核通过'
      create_review_log(@supplier_product, current_user.id, txt)
      return render json: {status: 200, msg: '审核通过', data: ''}
    end

    return render json: {status: 500, msg: "审核失败#{error_msg(@supplier_product)}", data: ''}
  end

  # 财务审核页面
  def cw_review_index
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品列表', s: 'mzc_review_index_products_search'}
    @q = Supplier::Product.where(status: 3).ransack(params[:q])
    @supplier_products = @q.result.includes(:brand, :category1, :category2, :category3).page(params[:page]).per(15)
  end

  # 财务审核
  def cw_review
    unless params[:review_status].to_i&.in? [0, 4]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    if @supplier_product.update_attribute(:status, params[:review_status])
      txt = params[:review_status].to_i == 0 ? '财务审核驳回' : '财务审核通过'
      create_review_log(@supplier_product, current_user.id, txt)
      return render json: {status: 200, msg: '审核通过', data: ''}
    end

    return render json: {status: 500, msg: "审核失败#{error_msg(@supplier_product)}", data: ''}
  end

  # 编辑审核页面
  def editor_review_index
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '商品列表', s: 'editor_review_index_products_search'}
    @q = Supplier::Product.where(status: 4).ransack(params[:q])
    @supplier_products = @q.result.page(params[:page]).per(15)
  end

  # 编辑审核
  def bj_review
    unless params[:review_status].to_i&.in? [0, 5]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    ActiveRecord::Base.transaction do
      if @supplier_product.update_attribute(:status, params[:review_status])
        @supplier_product.sync!(current_user.id) if @supplier_product.status == 5
        return render json: {status: 200, msg: '审核通过', data: ''}
      end
    end

    return render json: {status: 500, msg: "审核失败#{error_msg(@supplier_product)}", data: ''}
  end

  # 上下架
  def shelf
    # @auction_product.status == 5 &&
    if @auction_product.update_attribute(:published, params[:shelf_status])
      @auction_product.shelf_sync!
      return render json: {status: 200, msg: '操作成功', data: ''}
    end

    # if @auction_product.status != 5 && params[:shelf_status] == '0' && @auction_product.update_attributes!(published: params[:shelf_status])
    #   return render json: {status: 200, msg: '操作成功', data: ''}
    # end

    return render json: {status: 500, msg: "操作失败#{error_msg(@auction_product)}", data: ''}
  end

  # 改价
  def change_discount
    if @auction_product.profit_margin < Setting.change_discount_warning
      return render json: {status: 500, msg: "改价失败，毛利率不能小于#{(Setting.change_discount_warning * 100).to_i}%", data: ''}
    end
    if @auction_product.update_attributes!(discount: params[:new_discount])
      return render json: {status: 200, msg: '改价成功', data: ''}
    end

    return render json: {status: 500, msg: "改价失败#{error_msg(@auction_product)}", data: ''}
  end

  # 获取属性
  def get_attributes
    category = Auction::Category.find params[:category_id]
    @attributes = category.own_attributes
    return render partial: 'supplier/products/attribute_form'
  end

  def get_next_categories
    @categories = Auction::Category.next_categories params[:category_id]
    if !@categories.blank?
      return render json: {status: 200, msg: '有下级', data: @categories}
    else
      return render json: {status: 500, msg: '该分类没有下级', data: ''}
    end
  end

  def editor_edit
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '编辑编辑商品'}
    # images = Auction::Image.get_image_url @supplier_product
    # @img_paths = images[:img_paths]
    @images = @supplier_product.images.order(:sequence)
    @skus = @supplier_product.skus
    @attributes = @supplier_product.last_category&.own_attributes
    @values = @supplier_product.values.to_a
  end

  def editor_update
    begin
      ActiveRecord::Base.transaction do
        supplier_product_params.extract!('price', 'discount', 'provider_price')
        if @supplier_product.update_attributes!(supplier_product_params)
          Auction::Image.change_image_url @supplier_product, params[:image_urls], current_user.id
          @supplier_product.update_values!(params[:category_attributes], params[:attributes_names])
          flash[:success] = '修改商品成功！'
        end
      end
    rescue Exception => e
      flash[:danger] = "修改商品失败！#{error_msg(@supplier_product)}"
    end

    return redirect_to action: :editor_edit, id: @supplier_product.id
  end

  def image_form
    @img_id = params[:random_id]&.to_s
    @imageurl = params[:imageurl]
    render partial: 'image_form'
  end

  def destroy_image
    image = Auction::Image.find_by(id: params[:image_id].to_i)
    if image && image.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def batch_shelf
    ids = params[:pids]&.split(',') - ['']
    auction_products = Auction::Product.where(id: ids)
    begin
      auction_products.update_all(published: params[:shelf_status])
    rescue Exception => e
      flash[:danger] = "操作失败！"
    end
  end

  def batch_ms_review
    unless params[:review_status].to_i.in? [0, 2]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    ids = params[:pids]&.split(',') - ['']
    supplier_products = Supplier::Product.where(id: ids)
    begin
      supplier_products.update_all(status: params[:review_status])
      txt = params[:review_status].to_i == 0 ? '买手审核驳回' : '买手审核通过'
      create_review_log(supplier_products.to_a, current_user.id, txt)
    rescue Exception => e
      flash[:danger] = "操作失败！"
    end
  end

  def batch_zj_review
    unless params[:review_status].to_i.in? [0, 3]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    ids = params[:pids]&.split(',') - ['']
    supplier_products = Supplier::Product.where(id: ids)
    begin
      ActiveRecord::Base.transaction do
        supplier_products.update_all(status: params[:review_status])
        txt = params[:review_status].to_i == 0 ? '总监审核驳回' : '总监审核通过'
        create_review_log(supplier_products.to_a, current_user.id, txt)
        supplier_products.each do |sp|
          if params[:review_status].to_i == 3 && sp.profit_margin >= Setting.warning_value
            sp.update_attribute(:status, 4)
          end
        end
      end
    rescue Exception => e
      flash[:danger] = "操作失败！"
    end
  end

  def batch_cw_review
    unless params[:review_status].to_i.in? [0, 4]
      return render json: {status: 500, msg: "没有权限", data: ''}
    end

    ids = params[:pids]&.split(',') - ['']
    supplier_products = Supplier::Product.where(id: ids)
    begin
      supplier_products.update_all(status: params[:review_status])
      txt = params[:review_status].to_i == 0 ? '财务审核驳回' : '财务审核通过'
      create_review_log(supplier_products.to_a, current_user.id, txt)
    rescue Exception => e
      flash[:danger] = "操作失败！"
    end
  end

  def review_log
    @bread_menu = {m1: '商品管理', m2: '商品管理', m2_url: '/auction/products', m3: '审核记录', s: 'products_review_log_search'}
    params[:q][:s] = 'created_at desc'
    @q = Auction::ReviewLog.ransack(params[:q])
    @review_logs = @q.result.includes(:table, :editor).page(params[:page]).per(15)
  end

  def batch_edit_form
    @product_ids = (params[:pids]&.split(',') - [''])&.join(',')
    @item_type_val = params[:item_type_val]
    return render partial: 'batch_edit_form'
  end

  def batch_update
    pids = params[:pids]&.split(',')
    products = Auction::Product.where(id: pids)

    if params[:item_type] == 'label'
      products.update_all(label: params[:content])
    elsif params[:item_type] == 'keywords'
      products.update_all(keywords: params[:content])
    end
    flash[:success] = '批量修改成功'
    return redirect_to action: :index
  end


  private
    def set_supplier_product
      @supplier_product = Supplier::Product.find(params[:id]) if params[:id]
    end

    def set_auction_product
      @auction_product = Auction::Product.find(params[:id]) if params[:id]
    end

    def supplier_product_params
      # params.fetch(:auction_product, {})
      params.require(:supplier_product).permit!
    end

    def auction_product_params
      params.require(:auction_product).permit!
    end

    def create_review_log product, editor_id, result
      if product.is_a?(Array)
        product.each do |p|
          # Auction::ReviewLog.create(product_id: p.id, product_name: p.name, discount: p.discount, provider_price: p.provider_price, profit_margin: p.profit_margin, editor_id: editor_id, review_result: result)
          p.review_logs.create(product_name: p.name, discount: p.discount, provider_price: p.provider_price, profit_margin: p.profit_margin, editor_id: editor_id, review_result: result)
        end
      else
        # Auction::ReviewLog.create(product_id: product.id, product_name: product.name, discount: product.discount, provider_price: product.provider_price, profit_margin: product.profit_margin, editor_id: editor_id, review_result: result)
        product.review_logs.create(product_name: product.name, discount: product.discount, provider_price: product.provider_price, profit_margin: product.profit_margin, editor_id: editor_id, review_result: result)
      end
    end


end
