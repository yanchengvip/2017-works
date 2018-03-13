class PackageTypesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_package_type
  before_action :side_menus

  def index
    @package_types = PackageType.active.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @package_type = PackageType.new
  end

  def create
    package_type = PackageType.new(package_type_params)
    if package_type.save
      return flash_msg('success', '添加礼包分类成功！', 'index')
    end
    return flash_msg('danger', '添加礼包分类失败，分类名称不能重复！', 'new')
  end

  def edit

  end

  def update
    if @package_type.update(package_type_params)
      return flash_msg('success', '添加礼包分类成功！', 'index')
    end
    flash['danger'] = '添加礼包分类失败，分类名称不能重复！'
    return redirect_to action: "edit", id: @package_type.id
  end

  def destroy
    if @package_type.packages.present?
      return render json: {status: 403, msg: '有礼包使用了该分类，不能删除'}
    end
    if @package_type.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  private
  def set_package_type
    @package_type = PackageType.find(params[:id]) if params[:id]
  end

  def package_type_params
    params.require(:package_type).permit(:name, :remark, :sale_channel)
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu2]
  end
end
