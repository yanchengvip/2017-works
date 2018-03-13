class Supplier::ProductsController < Supplier::ApplicationController
  before_action :set_supplier_product, only: [:show, :edit, :update, :destroy, :review, :get_attributes, :check_status]
  before_action :check_status, except: [:show]

  # GET /auction/products
  # GET /auction/products.json
  def index
    @q = Supplier::Product.where(provider_id: current_user.id).ransack(params[:q])
    @supplier_products = @q.result.includes(:brand, :skus).page(params[:page]).per(15)
  end

  # GET /auction/products/1
  # GET /auction/products/1.json
  def show
    @skus = @supplier_product.skus
    @values = @supplier_product.values.group_by{|v| v.attribute_name}
    @images = @supplier_product.images
  end

  # GET /auction/products/new
  def new
    @supplier_product = Supplier::Product.new
    @values = @supplier_product.values.to_a
  end

  # GET /supplier/products/1/edit
  def edit
    # images = Auction::Image.get_image_url @supplier_product
    @images = @supplier_product.images
    # @img_paths = images[:img_paths]
    @skus = @supplier_product.skus
    @attributes = @supplier_product.last_category&.own_attributes
    @values = @supplier_product.values.to_a
  end

  # POST /auction/products
  # POST /auction/products.json
  def create
    if params[:skus].blank? || params[:category_attributes].blank?
      flash[:danger] = "添加商品失败，sku或属性不能为空！"
      return redirect_to action: :new
    end
    params[:skus] ||= []
    supplier_product = Supplier::Product.new(supplier_product_params.merge(provider_id: current_user.id, unsold_count: params[:skus].inject(0){|sum,x| sum+= x["amount"].to_f}))

    begin
      ActiveRecord::Base.transaction do
        if supplier_product.save!
          # Auction::Image.change_image_url supplier_product, params[:image_urls], current_user.id
          supplier_product.save_images!(params['pimages'], current_user.id)
          supplier_product.save_skus!(params[:skus], current_user.id)
          supplier_product.update_values!(params[:input_category_attributes], params[:category_attributes], params[:attributes_names], params[:custom_values])
          # flash_msg('success', '添加商品成功！', 'index')
          flash[:success] = '添加商品成功！'
          return redirect_to action: :index
        end
      end
    rescue Exception => e
      flash[:danger] = "添加商品失败！#{error_msg(supplier_product)}"
      return redirect_to action: :new
      # flash_msg('danger', "添加商品失败！#{error_msg(supplier_product)}", 'new')
    end
  end

  # PATCH/PUT /auction/products/1
  # PATCH/PUT /auction/products/1.json
  def update
    unless @supplier_product.status&.in?([0, 5])
      flash[:danger] = "审核中！"
      return redirect_to action: :index
    end
    if params[:skus].blank? || params[:category_attributes].blank?
      flash[:danger] = "添加商品失败，sku或属性不能为空！"
      return redirect_to action: :edit, id: @supplier_product.id
    end

    begin
      ActiveRecord::Base.transaction do
        if @supplier_product.update_attributes!(supplier_product_params.merge(provider_id: current_user.id, status: 0, unsold_count: params[:skus].inject(0){|sum,x| sum+= x["amount"].to_f}))
          # Auction::Image.change_image_url @supplier_product, params[:image_urls], current_user.id
          @supplier_product.save_images!(params['pimages'], current_user.id)
          @supplier_product.update_skus!(params[:skus], current_user.id)
          # binding.pry
          @supplier_product.update_values!(params[:input_category_attributes], params[:category_attributes], params[:attributes_names], params[:custom_values])
          flash[:success] = '修改商品成功！'
          return redirect_to action: :index
        end
      end
    rescue Exception => e
      flash[:danger] = "修改商品失败！#{error_msg(@supplier_product)}"
      return redirect_to action: :edit, id: @supplier_product.id
    end
  end

  # DELETE /auction/products/1
  # DELETE /auction/products/1.json
  def destroy
    @supplier_product.destroy
    respond_to do |format|
      format.html { redirect_to supplier_products_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def item_form
  #   render partial: 'item_form'
  # end

  # 审核
  def review
    if @supplier_product.update_attributes!(status: params[:review_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: "操作失败！#{error_msg(@supplier_product)}"}
  end

  # sku添加
  def sku_form
    render partial: 'sku_form'
  end

  # 删除某个sku
  def destroy_sku
    sku = Auction::Sku.find_by(id: params[:sku_id].to_i)
    if sku && sku.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def custom_value_form
    render partial: 'custom_value_form'
  end

  def destroy_custom_value
    value = Auction::Value.find_by(id: params[:value_id].to_i)
    if value && value.update_attribute(:active, false)
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  # 获取属性
  def get_attributes
    category = Auction::Category.find params[:category_id]
    @attributes = category.own_attributes
    return render partial: 'attribute_form'
  end

  def get_next_categories
    @categories = Auction::Category.next_categories params[:category_id]

    if !@categories.blank?
      return render json: {status: 200, msg: '有下级', data: @categories}
    else
      return render json: {status: 500, msg: '该分类没有下级', data: ''}
    end
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



  #excel导入商品
  def import_products

  end
  def create_import_products
    #Supplier::Product.import_products_from_excel 'public/products.xlsx'
    if params[:supplier_product].nil?
      redirect_to import_products_supplier_products_path,notice: '导入商品文件不能为空！' and return
    end
    uploader = ExcelUploader.new()
    uploader.store!(params[:supplier_product][:excel_file])
    file_path = 'public'+ uploader.url
    Supplier::Product.import_products_from_excel file_path,current_user
    redirect_to import_products_supplier_products_path,notice: '导入商品成功！'
  end

  private
  def set_supplier_product
    @supplier_product = Supplier::Product.includes(:images, :brand).find(params[:id]) if params[:id]
  end

  def supplier_product_params
    # params.fetch(:supplier_product, {})
    params.require(:supplier_product).permit!
  end

  def check_status
    return redirect_to '/403.html' if @supplier_product && (!@supplier_product.status&.in?([0, 5]) || @supplier_product.provider_id != current_user.id)
  end

end
