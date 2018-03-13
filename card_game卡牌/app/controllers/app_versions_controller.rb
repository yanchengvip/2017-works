class AppVersionsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_app_version
  before_action :side_menus

  def index
    @app_versions = AppVersion.active.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @app_version = AppVersion.new
  end

  def create
    app_version = AppVersion.new(app_version_params)
    if app_version.save
      return flash_msg('success', '添加新版本成功！', 'index')
    end
    return flash_msg('danger', '添加新版本失败！', 'new')
  end

  def edit

  end

  def update
    if @app_version.update(app_version_params)
      return flash_msg('success', '添加新版本成功！', 'index')
    end
    flash['danger'] = '添加新版本失败！'
    return redirect_to action: "edit", id: @app_version.id
  end

  def destroy
    if @app_version.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  private
  def app_version_params
    params.require(:app_version).permit(:app_name, :version, :mode, :update_url, :desc, :open_url)
  end

  def set_app_version
    @app_version = AppVersion.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end
end
