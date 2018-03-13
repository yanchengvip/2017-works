class MailTypesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus9
  before_action :set_mail_type
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = MailType.active.ransack(params[:q])
    @mail_types = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @mail_type = MailType.new
  end

  def create
    mt = MailType.active.where(name: mail_type_params[:name])
    if mt.present?
      flash[:success] = '类别名称不能重复！'
      return render action: :new
    end

    mt = MailType.new(mail_type_params)
    if mt.save
      flash[:success] = '添加类别成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加类别失败！'
      return render action: :new
    end
  end


  def edit; end

  def update
    mt = MailType.active.where(name: mail_type_params[:name]).first
    if mt.present? && mt.id != @mail_type.id
      flash[:danger] = '类别名称不能重复！'
      return redirect_to action: :edit, id: @mail_type.id
    end

    if @mail_type.update_attributes(mail_type_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @mail_type.id
    end
  end


  def destroy
    if @mail_type.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def able
    if @mail_type.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def mail_type_params
    params.require(:mail_type).permit!
  end

  def set_mail_type
    @mail_type = MailType.find(params[:id]) if params[:id]
  end


end
