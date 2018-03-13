class MsgChatsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus9
  before_action :set_mail
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = MsgChat.active.ransack(params[:q])
    @msg_chats = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @msg_chat = MsgChat.new
  end

  def create
    mc = MsgChat.new(msg_chat_params)
    if mc.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！'
      return render action: :new
    end
  end

  def edit

  end

  def update
    if @msg_chat.update_attributes(msg_chat_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @msg_chat.id
    end
  end

  def destroy
    if @msg_chat.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def able
    if @msg_chat.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def msg_chat_params
    params.require(:msg_chat).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_mail
    @msg_chat = MsgChat.find(params[:id]) if params[:id]
  end


end
