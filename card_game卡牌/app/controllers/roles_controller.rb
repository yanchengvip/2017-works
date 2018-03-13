class RolesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus3
  before_filter :set_role
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @roles = Role.includes(:authority_resources).active.page(params[:page].to_i).per(20)
  end

  def new
    @resources = AuthorityResource.active
  end

  def create

    flash[:success] = '添加失败'
    ActiveRecord::Base.transaction do
      role = Role.create!(role_params)
      params[:authority_resource_ids].each do |id|
        role.role_authority_resources.create!(authority_resource_id: id)
      end
      flash[:success] = '添加成功'
    end

    redirect_to '/roles'
  end

  def edit
    @selected_resource_ids = @role.role_authority_resources.pluck(:authority_resource_id)
    @resources = AuthorityResource.active
  end

  def update
    new_ids = params[:authority_resource_ids]
    old_ids = @role.role_authority_resources.active.pluck(:authority_resource_id)
    del_ids = old_ids - new_ids
    add_ids = new_ids - old_ids
    ActiveRecord::Base.transaction do
      @role.update_attributes!(role_params)
      del_ids.each do |id|
        @role.role_authority_resources.where(authority_resource_id: id).first.destroy!
      end
      add_ids.each do |id|
        @role.role_authority_resources.create!(authority_resource_id: id)
      end
    end
    flash[:success] = '修改成功'
    redirect_to '/roles'
  end

  def destroy
    @role.destroy
    flash[:success] = '删除成功'
    redirect_to '/roles'
  end


  private

  def set_role
    @role = Role.includes(:role_authority_resources).find(params[:id]) if params[:id]
  end

  def role_params
    params.permit(:name, :remark)
  end

end
