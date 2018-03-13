class SettingsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus10
  before_action :set_setting
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = Setting.active.ransack(params[:q])
    @settings = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @setting = Setting.new
  end

  def create
    @setting = Setting.new(setting_params)
    if @setting.save
      flash[:success] = '添加成功！'
      @setting.push_to_java
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！' + error_msg(@setting)
      return render action: :new
    end
  end

  def edit;end

  def update
    if @setting.update_attributes(setting_params)
      flash[:success] = '修改成功！'
      @setting.push_to_java
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！' + error_msg(@setting)
      return redirect_to action: :edit, id: @setting.id
    end
  end

  def destroy
    if @setting.destroy
      @setting.push_to_java
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def active_user
    @active_type = Setting.find_by(var: 'active_type')
    @active_value = Setting.find_by(var: 'active_value')
    @new_user_play_count = Setting.find_by(var: 'new_user_play_count')
    @old_user_play_count = Setting.find_by(var: 'old_user_play_count')
  end

  def save_active_user
    @active_type = Setting.find_by(var: 'active_type')
    @active_value = Setting.find_by(var: 'active_value')
    @new_user_play_count = Setting.find_by(var: 'new_user_play_count')
    @old_user_play_count = Setting.find_by(var: 'old_user_play_count')
    memo = params[:active_type].to_i == 1 ? '按日' : '按周'
    if @active_type.blank?
      Setting.create(var: 'active_type', value: params[:active_type], memo: memo)
    else
      @active_type.update_attributes(value: params[:active_type], memo: memo)
    end
    if @active_value.blank?
      Setting.create(var: 'active_value', value: params[:active_value])
    else
      @active_value.update_attributes(value: params[:active_value])
    end

    if @new_user_play_count.blank?
      Setting.create(var: params[:new_var], value: params[:new_value], memo: params[:new_memo])
    else
      @new_user_play_count.update_attributes(value: params[:new_value], memo: params[:new_memo])
    end

    if @old_user_play_count.blank?
      Setting.create(var: params[:old_var], value: params[:old_value], memo: params[:old__memo])
    else
      @old_user_play_count.update_attributes(value: params[:old_value], memo: params[:old__memo])
    end

    return redirect_to action: :index
  end

  private

  def setting_params
    params.require(:setting).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_setting
    @setting = Setting.find(params[:id]) if params[:id]
  end


end
