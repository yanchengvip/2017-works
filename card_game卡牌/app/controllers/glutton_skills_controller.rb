class GluttonSkillsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus3
  before_action :set_glutton_skill
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = GluttonSkill.active.ransack(params[:q])
    @glutton_skills = @q.result.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @glutton_skill = GluttonSkill.new
  end

  def create
    gs = GluttonSkill.new(glutton_skill_params)
    if gs.save
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
    if @glutton_skill.update_attributes(glutton_skill_params)
      flash[:success] = '修改成功！'
      return redirect_to action: :index
    else
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @glutton_skill.id
    end
  end

  def destroy
    if @glutton_skill.destroy
      flash[:success] = '删除成功！'
    elsif
      flash[:danger] = '删除失败！'
    end
    redirect_to action: :index
  end

  def able
    if @glutton_skill.update_attributes!(status: params[:able_status])
      return render json: {status: 200, msg: '操作成功！'}
    end
    return render json: {status: 500, msg: '操作失败！'}
  end


  private

  def glutton_skill_params
    params.require(:glutton_skill).permit!
    # params.permit(:need_count, :status, :reward_times, :thumbnail)
  end

  def set_glutton_skill
    @glutton_skill = GluttonSkill.find(params[:id]) if params[:id]
  end


end
