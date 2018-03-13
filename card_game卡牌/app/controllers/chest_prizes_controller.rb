class ChestPrizesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus10
  before_action :set_chest_prize
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = ChestPrize.active.ransack(params[:q])
    @chest_prizes = @q.result.page(params[:page]).per(15)
  end

  def show;end

  def new
    @chest_prize = ChestPrize.new
  end

  def create
    @chest_prize = ChestPrize.new(chest_prize_params.merge(thumbnail: params[:thumbnail]))
    if @chest_prize.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '添加失败！'
    return render action: :new
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @chest_prize.thumbnail&.to_s
    @thumbnail_path = @chest_prize.thumbnail
  end

  def update
    if @chest_prize.update_attributes!(chest_prize_params.slice('postage').merge(thumbnail: params[:thumbnail]))
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '修改失败！'
    return redirect_to action: :edit, id: @chest_prize.id
  end

  def destroy
    if @chest_prize.chest_box_prizes.blank? && @chest_prize.destroy
      return render json: {status: 200, msg: '删除成功！'}
    else
      return render json: {status: 500, msg: '删除失败，该商品已被使用，不能删除！'}
    end
  end

  private

  def chest_prize_params
    params.require(:chest_prize).permit!
  end

  def set_chest_prize
    @chest_prize = ChestPrize.find(params[:id]) if params[:id]
  end


end
