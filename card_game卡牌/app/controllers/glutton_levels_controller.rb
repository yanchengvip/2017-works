class GluttonLevelsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus3
  before_action :set_glutton_level
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = GluttonLevel.active.ransack(params[:q])
    @glutton_levels = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @glutton_level = GluttonLevel.new
  end

  def create
    gl = GluttonLevel.new(glutton_level_params.merge(thumbnail: params[:thumbnail]).merge(unlock_thumbnail: params[:unlock_thumbnail]))
    begin
      ActiveRecord::Base.transaction do
        gl.save!
        gl.save_week_gifts!(params[:week_level_gifts])
        gl.save_up_gifts!(params[:up_level_gifts])
      end
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    rescue Exception => e
      @glutton_level = gl
      flash[:danger] = '添加失败！' + e.to_s
      return render action: :new
    end
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @glutton_level.thumbnail.to_s
    @thumbnail_path = @glutton_level.thumbnail
    @unlock_thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @glutton_level.unlock_thumbnail.to_s
    @unlock_thumbnail_path = @glutton_level.unlock_thumbnail
    @week_level_gifts = @glutton_level.level_gifts.where(gift_type: 0)
    @up_level_gifts = @glutton_level.level_gifts.where(gift_type: 1)
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @glutton_level.update_attributes!(glutton_level_params.merge(thumbnail: params[:thumbnail]).merge(unlock_thumbnail: params[:unlock_thumbnail]))
        @glutton_level.save_week_gifts!(params[:week_level_gifts])
        @glutton_level.save_up_gifts!(params[:up_level_gifts])
      end
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    rescue Exception => e
      flash[:danger] = '修改失败！' + e.to_s
      return render action: :edit, id: @glutton_level.id
    end
  end

  def destroy
    if @glutton_level.destroy
      # flash[:success] = '删除成功！'
      return render json: {status: 200, msg: '删除成功！'}
    else
      # flash[:danger] = '删除失败！'
      return render json: {status: 500, msg: '删除失败！'}
    end
    # redirect_to action: :index
  end

  def able
    if @glutton_level.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end

  def week_prop_form
    render partial: 'week_prop_form'
  end

  def up_prop_form
    render partial: 'up_prop_form'
  end

  def destroy_prop
    level_gift = LevelGift.find_by(id: params[:level_gift_id].to_i)
    if level_gift && level_gift.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end


  private

  def glutton_level_params
    params.require(:glutton_level).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_glutton_level
    @glutton_level = GluttonLevel.find(params[:id]) if params[:id]
  end


end
