class TreasureBoxsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus3
  before_action :set_treasure_box
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @setting = WebSetting.first
    @q = TreasureBox.active.ransack(params[:q])
    @treasure_boxs = @q.result.page(params[:page]).per(15)
  end

  def show;end

  def new
    @treasure_box = TreasureBox.new
  end

  def create
    @treasure_box = TreasureBox.new(treasure_box_params)
    if @treasure_box.save!
      flash[:success] = '添加成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '添加失败！'
    return render action: :new
  end

  def edit;end

  def update
    if @treasure_box.update_attributes!(treasure_box_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    end
    flash[:danger] = '修改失败！'
    return redirect_to action: :edit, id: @treasure_box.id
  end

  def destroy
    if @treasure_box.destroy
      flash[:success] = '删除成功！'
    else
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def destroy_jackpot
    level_gift = LevelGift.find_by(id: params[:level_gift_id].to_i)
    if level_gift && level_gift.destroy
      return render json: {status: 200, msg: 'success'}
    end
    return render json: {status: 500, msg: 'error'}
  end

  def manage_jackpot
    # @jackpots = @treasure_box.jackpots&.includes(jackpot_products: [:product, :game_prop])
    @jackpots = @treasure_box.jackpots&.includes(jackpot_products: [:product])
  end

  def new_jackpot
    if !@treasure_box.has_master?
      return redirect_to action: :new_master_jackpot, id: @treasure_box.id
    end
    return redirect_to action: :new_normal_jackpot, id: @treasure_box.id
  end

  def new_master_jackpot
  end

  def save_master_jackpot
    begin
      ActiveRecord::Base.transaction do
        @treasure_box.save_jackpot!(params[:jackpot], params[:jackpot_product_level1], params[:jackpot_product_level2], params[:jackpot_product_level3], true)
      end
      flash[:success] = '创建奖池母版成功'
      return redirect_to action: :manage_jackpot, id: @treasure_box.id
    rescue Exception => e
      flash[:danger] = '创建奖池母版失败'
      return render action: :new_master_jackpot
    end
  end

  def new_normal_jackpot
  end

  def save_normal_jackpot
  end

  def edit_jackpot
  end

  def edit_master_jackpot
  end

  def update_master_jackpot
  end

  def edit_normal_jackpot
  end

  def update_normal_jackpot
  end

  def level1_type
    @random_id = params[:random_id]
    return render partial: 'treasure_boxs/level1_form/radio'
  end

  def level1_form
    @random_id = params[:random_id]
    case params[:type].to_i
    when 1
      return render partial: 'treasure_boxs/level1_form/energy'
    when 2
      return render partial: 'treasure_boxs/level1_form/glory'
    when 3
      return render partial: 'treasure_boxs/level1_form/prop'
    when 4
      return render partial: 'treasure_boxs/level1_form/product'
    end
  end

  def level2_type
    @random_id = params[:random_id]
    return render partial: 'treasure_boxs/level2_form/radio'
  end

  def level2_form
    @random_id = params[:random_id]
    case params[:type].to_i
    when 1
      return render partial: 'treasure_boxs/level2_form/energy'
    when 2
      return render partial: 'treasure_boxs/level2_form/glory'
    when 3
      return render partial: 'treasure_boxs/level2_form/prop'
    when 4
      return render partial: 'treasure_boxs/level2_form/product'
    end
  end

  def level3_form
    @random_id = params[:random_id]
    case params[:type].to_i
    when 1
      return render partial: 'treasure_boxs/level3_form/energy'
    when 2
      return render partial: 'treasure_boxs/level3_form/glory'
    when 3
      return render partial: 'treasure_boxs/level3_form/prop'
    when 4
      return render partial: 'treasure_boxs/level3_form/product'
    end
  end

  def get_product
    @product = BattleProduct.active.where("id = ?", params[:pid]).first
    return render partial: 'product_form'
  end

  def get_jackpot_form
    if @treasure_box.has_master?
      return render partial: 'master_form'
    end
    return render partial: 'normal_form'
  end


  private

  def treasure_box_params
    params.require(:treasure_box).permit!
  end

  def set_treasure_box
    @treasure_box = TreasureBox.find(params[:id]) if params[:id]
  end


end
