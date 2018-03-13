class HeadFramesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus3
  before_action :set_head_frame
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = HeadFrame.active.ransack(params[:q])
    @head_frames = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @head_frame = HeadFrame.new
  end

  def create
    ul = {}
    ul = {use_limit: 0} if params[:always] == '0'
    mc = HeadFrame.new(head_frame_params.merge(thumbnail: params[:thumbnail]).merge(ul))
    if mc.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！'
      return render action: :new
    end
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @head_frame.thumbnail&.to_s
    @thumbnail_path = @head_frame.thumbnail
  end

  def update
    ul = {}
    ul = {use_limit: 0} if params[:always] == '0'
    if @head_frame.update_attributes(head_frame_params.merge(thumbnail: params[:thumbnail]).merge(ul))
      flash[:success] = '修改成功！'
      @head_frame.clear_redis_data
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @head_frame.id
    end
  end

  def destroy
    if @head_frame.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def able
    if @head_frame.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def head_frame_params
    params.require(:head_frame).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_head_frame
    @head_frame = HeadFrame.find(params[:id]) if params[:id]
  end


end
