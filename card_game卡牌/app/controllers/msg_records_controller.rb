class MsgRecordsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy,:up_published,:down_published]
  before_filter :set_msg_record
  before_filter :side_menus
  # before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = MsgRecord.active.where(msg_type: 1).ransack(params[:q])
    @msg_records = @q.result.page(params[:page]).per(15)
  end

  def notices
    @q = MsgRecord.active.where(msg_type: 2).ransack(params[:q])
    @msg_records = @q.result.page(params[:page]).per(15)
  end

  def activities
    @q = MsgRecord.active.where(msg_type: 3).ransack(params[:q])
    @msg_records = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @msg_record = MsgRecord.new(msg_type: params[:msg_type])
  end

  def edit
    @thumbnail = @msg_record.thumbnail.present? ? (FASTDFSCONFIG[:fastdfs][:tracker_url]+@msg_record.thumbnail) : ''
    @thumbnail_path = @msg_record.thumbnail
  end

  def create
    msg_type_str = msg_type_str(msg_record_params[:msg_type])
    msg_record = MsgRecord.new(msg_record_params)
    if msg_record.save_msg!(msg_record_params)
      flash[:success] = "新建#{msg_type_str}成功"
      return redirect_to action: :index, msg_type: msg_record.msg_type
    else
      flash[:danger] = "新建#{msg_type_str}失败"
      return redirect_to action: :index, msg_type: msg_record_params[:msg_type]
    end
  end

  def update
    msg_type_str = msg_type_str(@msg_record.msg_type)
    if @msg_record.update(msg_record_params)
      flash[:success] = "修改#{msg_type_str}成功"
      return redirect_to action: :index, msg_type: @msg_record.msg_type
    else
      flash[:danger] = "修改#{msg_type_str}失败"
      return redirect_to action: :edit, id: @msg_record.id
    end
  end
  #上架
  def up_published
    if @msg_record.update(:published => true)
      flash[:success] = "上架成功"
    else
      flash[:danger] = "上架失败"
    end
    return redirect_to action: :index, msg_type: @msg_record.msg_type
  end
  #下架
  def down_published
    if @msg_record.update(:published => false)
      flash[:success] = "下架成功"
    else
      flash[:danger] = "下架失败"
    end
    return redirect_to action: :index, msg_type: @msg_record.msg_type
  end

  def destroy
    if @msg_record.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 200, msg: 'success'}
  end


  private
  def msg_record_params
    params.permit(:id, :msg_type, :title, :summary, :content, :receiver, :is_show, :thumbnail)
  end

  def set_msg_record
    @msg_record = MsgRecord.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu5]
  end

  def msg_type_str(val)
    case val.to_i
    when 1
      res = '推送消息'
    when 2
      res = '公告'
    when 3
      res = '活动消息'
    else
      res = ''
    end

    return res
  end
end
