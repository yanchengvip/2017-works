class HeadimgsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :set_headimg
  before_action :side_menus3
  skip_before_action :verify_authenticity_token, only: [:update, :create]

  def index
    @images = Image.active.where(table_type: 'Headimg').page(params[:page]).per(10)
  end

  def new
  end

  def create
    image = Image.new(url: params[:url], table_type: 'Headimg')
    if image.save!
      return flash_msg('success', '上传头像成功！', 'index')
    end
    return flash_msg('danger', '上传头像失败，请重试！', 'new')
  end

  def destroy
    if @image.destroy
      return flash_msg('success', '头像删除成功！', 'index')
    end
    return flash_msg('danger', '头像删除失败，请重试！', 'index')
  end


  private
  def set_headimg
    @image = Image.find(params[:id]) if params[:id]
  end
end
