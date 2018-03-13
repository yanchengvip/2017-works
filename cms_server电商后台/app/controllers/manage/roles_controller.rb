class Manage::RolesController < ApplicationController
  before_action :set_manage_role, only: [:show, :edit, :update, :destroy]
  before_action :side_menus6
  # GET /manage/roles
  # GET /manage/roles.json
  def index
    @bread_menu = {m1: '角色管理', m2: '角色管理', m2_url: '/manage/providers', m3: '角色列表',add: '/manage/roles/new'}
    @manage_roles = Manage::Role.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /manage/roles/1
  # GET /manage/roles/1.json
  def show
  end

  # GET /manage/roles/new
  def new
    @bread_menu = {m1: '角色管理', m2: '角色管理', m2_url: '/manage/roles', m3: '角色列表',add: '/manage/roles/new'}
    @manage_role = Manage::Role.new
    #@authority_ids = Manage::Authority.active.pluck(:name, :id)
    res = Manage::Authority.active.pluck(:name, :id, :action)
    @result = res.group_by{|r| r[2].split('#')[0]}
    @manage_role_authorities_ids = @manage_role.authority_role_relationships.active.pluck(:authority_id)

  end

  # GET /manage/roles/1/edit
  def edit
    #@authority_ids = Manage::Authority.active.pluck(:name, :id)
    res = Manage::Authority.active.pluck(:name, :id, :action)
    @result = res.group_by{|r| r[2].split('#')[0]}
    @manage_role_authorities_ids = @manage_role.authority_role_relationships.active.pluck(:authority_id)
  end

  # POST /manage/roles
  # POST /manage/roles.json
  def create
    flash[:error] = '添加失败'
    ActiveRecord::Base.transaction do
      role = Manage::Role.create!(manage_role_params)
      manage_role_params[:authority_ids].each do |id|
        role.authority_role_relationships.create!(authority_id: id, role_id: role.id)
      end
      flash[:success] = '添加成功'
    end
    redirect_to '/manage/roles'
  end

  # PATCH/PUT /manage/roles/1
  # PATCH/PUT /manage/roles/1.json
  def update
    if @manage_role.update(manage_role_params)
      @manage_role.check_authority manage_role_params[:authority_ids]
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/manage/roles'
  end

  # DELETE /manage/roles/1
  # DELETE /manage/roles/1.json
  def destroy
    @manage_role.destroy
    respond_to do |format|
      format.html { redirect_to manage_roles_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_role
      @manage_role = Manage::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_role_params
      params.require(:manage_role).permit!
    end
end
