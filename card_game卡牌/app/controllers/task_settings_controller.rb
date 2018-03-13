class TaskSettingsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_task_setting
  before_filter :side_menus5
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = TaskSetting.active.ransack(params[:q])
    @task_settings = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @task_setting = TaskSetting.new
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @task_setting.thumbnail&.to_s
    @thumbnail_path = @task_setting.thumbnail
    @task_type = @task_setting.task_type
  end

  def create
    task_setting = TaskSetting.new(task_setting_params)
    begin
      ActiveRecord::Base.transaction do
        if task_setting.save!(task_setting_params)
          task_setting.save_task_items!(params[:task_items])
          return flash_msg('success', '添加成功！', 'index')
        end
      end
    rescue Exception => e
      return flash_msg('danger', "添加失败！#{error_msg(task_setting)}", 'new')
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if @task_setting.update_attributes!(task_setting_params)
        @task_setting.update_task_items!(params[:task_items])
        return flash_msg('success', '修改成功！', 'index')
      end
    end

    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @task_setting.id
  end

  def destroy
    if @task_setting.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 200, msg: 'success'}
  end

  def item_form
    render partial: 'item_form', item_type_val: params[:item_type_val]
  end

  # 删除某个内容
  def destroy_item
    task_item = TaskItem.find_by(id: params[:task_item_id].to_i)
    if task_item && task_item.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def dynamic
    @task_type = params[:task_type].to_i
    return render partial: 'dynamic'
  end


  private
  def task_setting_params
    params.permit(:task_type, :task_name, :need_count, :status, :reward_times, :thumbnail, :task_remark, :energy_num, :receive_user_num, :expire_time, :from_win_num, :from_fail_num,:direction_type)
  end

  def set_task_setting
    # @task_setting = TaskSetting.find(params[:id]) if params[:id]
    @task_setting = TaskSetting.includes(:task_items).where(id: params[:id]).first
  end


end
