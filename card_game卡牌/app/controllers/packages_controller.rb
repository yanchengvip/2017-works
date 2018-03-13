class PackagesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:shelf]
  before_action :set_package
  before_action :side_menus
  before_action :init_params_search, only: [:index, :buy_record]
  skip_before_action :verify_authenticity_token, only: [:create, :update, :save_scheme]

  def index
    @q = Package.active.ransack(params[:q])
    @packages = @q.result.includes(:package_type, :battle_packages).page(params[:page]).per(15)
  end

  def show
    @cards = Card.active
  end

  def new
    @package = Package.new
    @package_types = PackageType.active
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @package = Package.new(package_params)
        if @package.save_package(params)
          @package.save_package_items(params[:package_items])
          return flash_msg('success', '礼包添加成功！', 'index')
        else
          return flash_msg('danger', "礼包添加失败1！#{error_msg(@package)}", 'new')
        end
      end
    rescue Exception => e
      return flash_msg('danger', "礼包添加失败2！#{error_msg(@package)}", 'new')
    end
  end

  def edit
    @package_types = PackageType.active.where(sale_channel: @package.sale_channels)

    # images = Image.get_image_url @package
    # @img_paths = images[:img_paths]
    # @thumbnail = @package.thumbnail.present? ? (FASTDFSCONFIG[:fastdfs][:tracker_url]+@package.thumbnail) : ''
    # @thumbnail_path = @package.thumbnail
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        # origin_prize_type = @package.prize_type
        if @package.update_package(package_params)
          @package.update_package_items(params[:package_items])
          # Image.change_image_url @package, params[:image_urls]
          # @package.operate_logs.create(current_user, exec_action: 'update', '修改礼包')
          # OperateLog.log(current_user, 'update', @package, '修改礼包')
          return flash_msg('success', '修改成功！', 'index')
        end
      end
    rescue Exception => e
      flash[:danger] = '修改失败！'
      redirect_to action: :edit, id: @package.id
    end
  end

  def destroy
    if @package.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  # 上下架
  def shelf
    if @package.package_items.blank?
      return render json: {status: 500, msg: '礼包内容为空'}
    end

    begin
      if @package.prize_type == 3 && !@package.item_scheme_price_ok
        return render json: {status: 500, msg: "操作失败，方案配置超出礼包配置价值范围"}
      end
      if params[:shelf_status].to_i == 1
        @package.update_attributes!(status: params[:shelf_status], onshelf_time: Time.now)
      elsif params[:shelf_status].to_i == -1
        @package.update_attributes!(status: params[:shelf_status], offshelf_time: Time.now)
      end
      return render json: {status: 200, msg: '操作成功'}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败"}
    end
  end

  def content_form
    # render partial: 'content_form', form_id: params[:form_type]
    render partial: 'content_form', item_type_val: params[:item_type_val]
  end

  def buy_record
    @q = PackageOrder.active.ransack(params[:q])
    @package_orders = @q.result.includes(:user, :package, :package_order_items).page(params[:page]).per(15)

    respond_to do |format|
      format.html
      format.csv {send_data(PackageOrder.export_excel(@package_orders), :type => "text/excel;charset=utf-8; header=present", :filename => '礼包购买记录.csv' )}
    end
  end

  # 渠道对应分类
  def get_package_type
    @package_types = PackageType.where(sale_channel: params[:sale_channel])
    render partial: 'package_type'
  end

  # 等值随机礼包的中奖方案设置
  def prize_scheme
    if @package.status == 1
      flash[:danger] = '已上架，不能修改方案！'
      return redirect_to action: :index
    end
    @cards = Card.active
  end

  # 保存中奖方案
  def save_scheme
    over_range = SYSTEMCONFIG[:admin_config][:fix_price_over].presence || 10
    if (params[:package_items_price].to_f - @package.fix_price.to_f).abs > over_range
      flash[:danger] = "保存失败，方案总价值不能相差礼包设定价值上下 #{over_range} 微集分"
      redirect_to action: :prize_scheme, id: params[:id]
    end
    begin
      ActiveRecord::Base.transaction do
        if @package.save_package_item_scheme(params)
          flash[:success] = '保存成功'
        else
          flash[:danger] = '数据错误，保存失败'
        end
        redirect_to action: :prize_scheme, id: params[:id]
      end
    rescue Exception => e
      p e.to_s
      flash[:danger] = '保存失败'
      return redirect_to action: :prize_scheme, id: params[:id]
    end
  end

  def scheme_form
    @cards = Card.active
    render partial: 'scheme_form', tab_id: params[:tab_id]
  end

  # 查看等值随机礼包中奖方案
  def show_scheme
    @cards = Card.active
  end

  # 删除中奖方案
  def destroy_item_scheme
    package_item = PackageItem.where("id = ?", params[:item_id]).first
    if package_item.destroy
      flash[:success] = '删除成功'
    else
      flash[:success] = '删除失败'
    end
    return redirect_to action: :prize_scheme, id: params[:id]
  end

  private
  def package_params
    params.permit(:name, :package_type_id, :price, :summary, :saled_count, :sale_channels)
    # params.permit(:name, :package_type_id, :price, :summary, :status, :onshelf_time, :offshelf_time, :thumbnail, :details, :total_count, :total_limit, :saled_count, :left_count, :day_limit, :prize_type, :sale_channels, :fix_price)
  end

  def set_package
    @package = Package.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu2]
  end

end
