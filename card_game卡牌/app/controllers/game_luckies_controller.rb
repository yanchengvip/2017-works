class GameLuckiesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_filter :set_game_lucky
  before_filter :side_menus5
  # before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = GameLucky.active.ransack(params[:q])
    @game_luckies = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @game_lucky = GameLucky.new(win_type: 0)
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @game_lucky.thumbnail.to_s
    @thumbnail_path = @game_lucky.thumbnail
    @headimg = FASTDFSCONFIG[:fastdfs][:tracker_url] + @game_lucky.headimg.to_s
    @headimg_path = @game_lucky.headimg
  end

  def create
    @game_lucky = GameLucky.new(game_lucky_params.merge(thumbnail: params[:thumbnail]).merge(headimg: params[:headimg]))
    if @game_lucky.save
      GameLucky.clear_redis_data
      return flash_msg('success', '添加成功！', 'index')
    end
    return flash_msg('danger', "添加失败！#{error_msg(@game_lucky)}", 'new')
  end

  def update
    if @game_lucky.update_attributes!(game_lucky_params.merge(thumbnail: params[:thumbnail]).merge(headimg: params[:headimg]))
      GameLucky.clear_redis_data
      return flash_msg('success', '修改成功！', 'index')
    end
    flash['danger'] = '修改失败！'
    return redirect_to action: :edit, id: @game_lucky.id
  end

  def destroy
    if @game_lucky.destroy
      GameLucky.clear_redis_data
      return flash_msg('success', '删除成功！', 'index')
    end
    return flash_msg('danger', '删除失败！', 'index')
  end


  private
  def game_lucky_params
    params.require(:game_lucky).permit(:thumbnail, :price, :headimg, :nickname, :win_type, :remark)
  end

  def set_game_lucky
    @game_lucky = GameLucky.find(params[:id]) if params[:id]
  end


end

