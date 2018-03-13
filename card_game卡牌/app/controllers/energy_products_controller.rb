class EnergyProductsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:shelf]
  before_filter :set_energy_product
  before_filter :side_menus2
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = EnergyProduct.active.ransack(params[:q])
    @energy_products = @q.result.includes(:energy_product_gifts).page(params[:page]).per(15)
  end

  def show
    @energy_product_gifts = @energy_product.energy_product_gifts
  end

  def new
    @energy_product = EnergyProduct.new
  end

  def create
    buy_times = params[:energy_product_gifts].map{|e| e['buy_times']} if params[:energy_product_gifts]
    if buy_times.present? && buy_times.size != buy_times.uniq.size
      return flash_msg('danger', "添加失败，次数不能重复！", 'new')
    end

    @energy_product = EnergyProduct.new(energy_product_params)
    ActiveRecord::Base.transaction do
      if @energy_product.save
        @energy_product.save_energy_product_gifts!(params[:energy_product_gifts])
        return flash_msg('success', '添加成功！', 'index')
      end
    end

    return flash_msg('danger', "添加失败！#{error_msg(@energy_product)}", 'new')
  end

  def edit
    @energy_product_gifts = @energy_product.energy_product_gifts
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@energy_product.thumbnail&.to_s
    @thumbnail_path = @energy_product.thumbnail
  end

  def update
    buy_times = params[:energy_product_gifts].map{|e| e['buy_times']} if params[:energy_product_gifts]
    if buy_times.present? && buy_times.size != buy_times.uniq.size
      flash['danger'] = '修改失败，次数不能重复！'
      return redirect_to action: :edit, id: @energy_product.id
    end

    ActiveRecord::Base.transaction do
      if @energy_product.update_attributes!(energy_product_params)
        @energy_product.update_energy_product_gifts!(params[:energy_product_gifts])
        return flash_msg('success', '修改成功！', 'index')
      end
    end

    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @energy_product.id
  end

  def destroy
    if @energy_product.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  def item_form
    render partial: 'item_form'
  end

  # 删除某个赠品
  def destroy_item
    energy_product_gift = EnergyProductGift.find_by(id: params[:energy_product_gift_id].to_i)
    if energy_product_gift && energy_product_gift.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  # 排序
  def get_order_num
    if energy_product = EnergyProduct.active.where('order_num = ?', params[:num]).first
      return render json: {status: 500, msg: '排序不能重复！', data: {name: energy_product.name}}
    end
    return render json: {status: 200, msg: 'success'}
  end

  def shelf
    begin
      if params[:shelf_status].to_i == 1
        @energy_product.update_attributes!(status: params[:shelf_status])
      elsif params[:shelf_status].to_i == -1
        @energy_product.update_attributes!(status: params[:shelf_status])
      end
      return render json: {status: 200, msg: '操作成功'}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败"}
    end
  end



  private
  def energy_product_params
    params.permit(:name, :energy_count, :price, :order_num, :thumbnail, :summary)
  end

  def set_energy_product
    # @model = EnergyProduct.find(params[:id]) if params[:id]
    @energy_product = EnergyProduct.includes(:energy_product_gifts).where(id: params[:id]).first
  end

end
