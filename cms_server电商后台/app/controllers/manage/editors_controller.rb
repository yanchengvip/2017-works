class Manage::EditorsController < ApplicationController
  before_action :set_manage_editor, only: [:show, :edit, :update, :destroy]
  before_action :side_menus6
  # GET /manage/editors
  # GET /manage/editors.json
  def index
    @bread_menu = {m1: '编辑管理', m2: '编辑管理', m2_url: '/manage/editors', m3: '编辑列表',add: '/manage/editors/new'}
    @manage_editors = Manage::Editor.active.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /manage/editors/1
  # GET /manage/editors/1.json
  def show
  end

  # GET /manage/editors/new
  def new
    @bread_menu = {m1: '编辑管理', m2: '编辑管理', m2_url: '/manage/editors', m3: '编辑列表',add: '/manage/editors/new'}
    @manage_editor = Manage::Editor.new
    @role_ids = Manage::Role.active.pluck(:name, :id)
    @departments = Manage::Editor::DEPARTMENTS.invert.to_a
    @manage_editor_roles_ids = @manage_editor.editor_role_relationships.active.pluck(:role_id)
  end

  # GET /manage/editors/1/edit
  def edit
    @role_ids = Manage::Role.active.pluck(:name, :id)
    @departments = Manage::Editor::DEPARTMENTS.invert.to_a
    @manage_editor_roles_ids = @manage_editor.editor_role_relationships.active.pluck(:role_id)
  end

  # POST /manage/editors
  # POST /manage/editors.json
  def create
    flash[:error] = '添加失败'
    ActiveRecord::Base.transaction do
      editor = Manage::Editor.create!(manage_editor_params)
      manage_editor_params[:role_ids].each do |id|
        editor.editor_role_relationships.create!(role_id: id, editor_id: editor.id)
      end
      flash[:success] = '添加成功'
    end
    redirect_to '/manage/editors'
  end

  # PATCH/PUT /manage/editors/1
  # PATCH/PUT /manage/editors/1.json
  def update
    if @manage_editor.update(manage_editor_params)
      @manage_editor.check_role manage_editor_params[:role_ids]
      flash[:success] = '修改成功'
    else
      flash[:error] = '修改失败'
    end
    redirect_to '/manage/editors'
  end

  # DELETE /manage/editors/1
  # DELETE /manage/editors/1.json
  def destroy
    @manage_editor.destroy
    respond_to do |format|
      format.html { redirect_to manage_editors_url, notice: 'Editor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_password
    @manage_editor = current_user
  end

  def update_password
    if Manage::Editor.login(current_user.email, params[:manage_editor][:password]) && params[:manage_editor][:new_password] == params[:manage_editor][:password_confirm] && !params[:manage_editor][:new_password].blank?
      current_user.update(password: params[:manage_editor][:new_password])
      redirect_to root_url, flash: {success: "密码修改成功"}
    else
      @manage_editor = current_user
      flash.now[:danger]= "密码错误或两次新密码不一致"
      render :reset_password
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manage_editor
      @manage_editor = Manage::Editor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_editor_params
      params.require(:manage_editor).permit!
    end
end
