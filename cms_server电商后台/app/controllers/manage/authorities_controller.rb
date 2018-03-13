class Manage::AuthoritiesController < ApplicationController
  before_action :set_manage_authority, only: [:show, :edit, :update, :destroy]
  before_action :side_menus6


  def index
    @bread_menu = {m1: '基本权限', m2: '基本权限', m2_url: '/manage/authorities', m3: '权限列表',add: '/manage/authorities/new'}
    @manage_authorities = Manage::Authority.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  def new
    @bread_menu = {m1: '基本权限', m2: '基本权限', m2_url: '/manage/authorities', m3: '权限列表',add: '/manage/authorities/new'}
    @manage_authority = Manage::Authority.new
  end

  def create
    @manage_authority = Manage::Authority.new(manage_authority_params)
    if @manage_authority.save
      flash[:success] = '创建成功'
    else
      flash[:error] = '创建失败'
    end
    redirect_to '/manage/authorities'
  end

  def update
    if @manage_authority.update(manage_authority_params)
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/manage/authorities'
  end

  def destroy
    @manage_authority.destroy
    respond_to do |format|
      format.html { redirect_to manage_authorities_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

    def set_manage_authority
      @manage_authority = Manage::Authority.find(params[:id])
    end

    def manage_authority_params
      params.require(:manage_authority).permit!
    end
end
