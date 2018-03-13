class CopiesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_copy
  before_action :side_menus
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = Copy.active.ransack(params[:q])
    @copies = @q.result.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @copy = Copy.new
  end

  def create
    copy = Copy.new(copy_params)
    if copy.save
      return flash_msg('success', '添加文案成功！', 'index')
    end
    return flash_msg('danger', '添加文案失败！', 'new')
  end

  def edit
    @thumbnail = @copy.thumbnail.present? ? (FASTDFSCONFIG[:fastdfs][:tracker_url]+@copy.thumbnail) : ''
    @thumbnail_path = @copy.thumbnail
  end

  def update
    if @copy.update(copy_params)
      return flash_msg('success', '修改文案成功！', 'index')
    end
    flash['danger'] = '修改文案失败！'
    return redirect_to action: "edit", id: @copy.id
  end

  def destroy
    res = @copy.destroy_copy
    if res[:result]
      return render json: {status: 200, msg: res[:msg]}
    end
    return render json: {status: 500, msg: res[:msg]}
  end


  private
  def copy_params
    params.permit(:title, :content, :thumbnail, :copy_type, :status, :url)
  end

  def set_copy
    @copy = Copy.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu9]
  end
end
