class AdminsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus
  before_action :set_admin
  before_action :check_parans, only: [:update]

  def index
    @admins = Admin.active.page(params[:page]).per(15)
  end

  def show
    @admin = current_user
  end

  def new
    @admin = Admin.new
    @roles = Role.active
    @admin_role_ids = @admin.roles.map(&:id)
  end

  def create
    params[:admin][:encrypted_password] = params[:password]
    if !params["password"].blank? && params[:admin]["phone"] && params[:admin]["phone"].match(/^1\d{10}$/)
      if params[:role_ids].blank?
        return flash_msg('danger', '至少必须选择一个角色！', 'new')
      end

      admin = Admin.new(admin_params)
      if admin.save
        params[:role_ids].each do |rid|
          admin.roles << Role.find(rid)
        end
        return flash_msg('success', '添加管理员成功！', 'index')
      else
        return flash_msg('danger', '添加管理员失败，用户名或手机号已存在！', 'new')
      end
    else
      return flash_msg('danger', '手机号或手机验证码错误！', 'new')
    end
  end

  def edit
    @roles = Role.active
    @admin_role_ids = @admin.roles.active.map(&:id)
  end

  def update
    if (current_user.is_super? || @admin.id == current_user.id) && @admin.update(admin_params)
      @admin.check_roles(params[:role_ids])
      return flash_msg('success', '操作成功！', 'index')
    end
    return flash_msg('danger', '修改失败！', 'edit')
  end

  def destroy
    if current_user.is_super? && @admin.nickname != 'admin' && @admin.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def change_pwd
  end

  # 修改密码
  def update_pwd
    if params[:admin][:password].strip.present? && (params[:admin][:password] == params[:admin][:password_confirmation]) && current_user.id == @admin.id
      current_user.update_attributes!(encrypted_password: params[:admin][:password])
      flash[:success] = '修改成功'
      session[:admin_id] = nil
      return redirect_to '/login'
    else
      flash[:danger] = '修改失败！'
      return redirect_to action:  'change_pwd', id: current_user.id
    end
  end

  # 重置密码
  def reset_pwd
    if current_user.is_super?
      if @admin.update_attributes!(encrypted_password: SYSTEMCONFIG[:admin_config][:reset_pwd])
        return render json: {status: 200, msg: "重置成功，密码已重置为#{SYSTEMCONFIG[:admin_config][:reset_pwd]}"}
      else
        return render json: {status: 500, msg: '重置失败，请重试'}
      end
    end
    return render json: {status: 500, msg: '没有权限！'}
  end


   def audited_type

   end
  def audited_logs
    @auditeds = Audited::Audit.where(auditable_type: params[:type]).order('created_at desc')
                    .page(params[:page]).per(15)
  end

  private
  def admin_params
    params.require(:admin).permit(:phone, :email, :encrypted_password, :nickname, :name)
  end

  def set_admin
    @admin = Admin.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end

  def check_parans
    if params[:role_ids].blank?
      flash[:danger] = '至少必须选择一个角色！'
      return redirect_to action: :edit, id: params[:id]
    end
  end
end
