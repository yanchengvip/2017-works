class GamePropsController < ApplicationController
  before_action :side_menus3
  before_action :set_game_prop
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def demons
    # @q = GameProp.active.where(prop_type: 3).ransack(params[:q])
    # @game_props = @q.result.page(params[:page]).per(15)
    @game_prop = GameProp.active.where(prop_type: 3).first || GameProp.new
    return redirect_to action: :new, prop_type: 3 if @game_prop.new_record?
  end

  def vouchers
    @q = GameProp.where(prop_type: 1).active.ransack(params[:q])
    @game_props = @q.result.page(params[:page]).per(15)
  end

  def silk_bags
    @q = GameProp.where(prop_type: 2).active.ransack(params[:q])
    @game_props = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @game_prop = GameProp.new(prop_type: params[:prop_type])
  end

  def create
    ul = {}
    ul = {use_limit: 0} if params[:always] == '0'
    mc = GameProp.new(game_prop_params.merge(thumbnail: params[:thumbnail]).merge(ul))
    if mc.save
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '添加失败！'
      return render action: :new
    end
  end

  def edit
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url] + @game_prop.thumbnail.to_s
    @thumbnail_path = @game_prop.thumbnail
    if @game_prop.prop_type == '2'
      @game_prop_coups = @game_prop.game_prop_coups.to_a
    end
  end

  def update
    ul = {}
    ul = {use_limit: 0} if params[:always] == '0'
    if @game_prop.update_attributes(game_prop_params.merge(thumbnail: params[:thumbnail]).merge(ul))
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @game_prop.id
    end
  end

  def create_demon
    demon = GameProp.new(game_prop_params.merge(prop_type: 3, name: '妖丹'))
    if demon.save
      flash[:success] = '添加成功！'
      GameProp.clear_redis_data
      return redirect_to action: :demons
    else
      flash[:danger] = '添加失败！'
      return redirect_to action: :new, prop_type: 3
    end
  end

  def update_demon
    if @game_prop.update_attributes(game_prop_params)
      flash[:success] = '修改成功！'
      GameProp.clear_redis_data
      return redirect_to action: :demons
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @game_prop.id
    end
  end

  def create_silk_bag
    silk_bag = GameProp.new(game_prop_params.merge(prop_type: 2).merge(thumbnail: params[:thumbnail]))
    begin
      ActiveRecord::Base.transaction do
        silk_bag.save!
        silk_bag.save_prop_coup!(params[:game_prop_coup])
      end
      flash[:success] = '添加成功！'
      return redirect_to action: :silk_bags
    rescue Exception => e
      flash[:danger] = '添加失败！'
      return redirect_to action: :new, prop_type: 2
    end
  end

  def update_silk_bag
    begin
      ActiveRecord::Base.transaction do
        @game_prop.update_attributes!(game_prop_params.merge(thumbnail: params[:thumbnail]))
        @game_prop.save_prop_coup!(params[:game_prop_coup])
      end
      flash[:success] = '修改成功！'
      return redirect_to action: :silk_bags
    rescue Exception => e
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @game_prop.id
    end
  end

  def create_voucher
    voucher = GameProp.new(game_prop_params.merge(prop_type: 1).merge(thumbnail: params[:thumbnail]))
    if voucher.save
      flash[:success] = '添加成功！'
      return redirect_to action: :vouchers
    else
      flash[:danger] = '添加失败！'
      return redirect_to action: :new, prop_type: 1
    end
  end

  def update_voucher
    if @game_prop.update_attributes(game_prop_params.merge(thumbnail: params[:thumbnail]))
      flash[:success] = '修改成功！'
      return redirect_to action: :vouchers
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @game_prop.id
    end
  end

  def destroy
    if @game_prop.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def get_card_form
    if params[:config_type] == '1'
      return render partial: 'appoint_card'
    elsif params[:config_type] == '2'
      return render partial: 'random_card'
    end
  end

  private

  def game_prop_params
    params.require(:game_prop).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_game_prop
    @game_prop = GameProp.find(params[:id]) if params[:id]
  end


end
