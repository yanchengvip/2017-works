class MailsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus9
  before_action :set_mail
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = MsgMail.active.ransack(params[:q])
    @mails = @q.result.includes(:mail_type).page(params[:page]).per(15)
  end

  def show
  end

  def new
    @mail = MsgMail.new
  end

  def create
    mt = MsgMail.new(mail_params.merge(thumbnail: params[:thumbnail]))
    if mt.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！'
      return render action: :new
    end
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @mail.thumbnail&.to_s
    @thumbnail_path = @mail.thumbnail
  end

  def update
    if @mail.update_attributes(mail_params.merge(thumbnail: params[:thumbnail]))
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @mail.id
    end
  end

  def destroy
    if @mail.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def able
    if @mail.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def mail_params
    params.require(:msg_mail).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_mail
    @mail = MsgMail.find(params[:id]) if params[:id]
  end


end
