class Mammon::PeriodsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus12
  before_action :set_period
  skip_before_action :verify_authenticity_token, only: [:save_rule, :give_card]

  def index
    @q = Mammon::Period.active.ransack(params[:q])
    @periods = @q.result.includes(:period_items).page(params[:page]).per(15)
  end

  def show
    @period_items = @period.period_items
  end

  def new
    @period = Mammon::Period.new(end_time: Date.today.to_s+ ' 21:00:00', code_count: 10000)
  end

  def create
    @period = Mammon::Period.new(period_params)
    begin
      ActiveRecord::Base.transaction do
        if @period.save!
          @period.save_items!(params[:period_item])
        end
        flash[:success] = '添加成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '添加失败！' + e.to_s
      return render action: :new
    end
  end

  def edit
    @period_items = @period.period_items.order(:prize_num)
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @period.update_attributes!(period_params)
          @period.save_items!(params[:period_item])
        end
        flash[:success] = '修改成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '修改失败！' + e.to_s
      return render action: :edit, id: @period.id
    end
  end

  def shelf
    begin
      if @period.update_attributes!(status: params[:shelf_status])
        return render json: {status: 200, msg: '操作成功'}
      end
      return render json: {status: 500, msg: "操作失败"}
    rescue Exception => e
      return render json: {status: 500, msg: "操作失败1"}
    end
  end

  def get_item_form
    case params[:prize_type].to_i
    when 1
      return render partial: 'item_form'
    when 2
      return render partial: 'voucher_item_form'
    when 3
      return render partial: 'bxf_item_form'
    end
  end

  def destroy_item
    begin
      ActiveRecord::Base.transaction do
        if rule_item = Mammon::PeriodItem.find_by(id: params[:rule_item_id].to_i)
          rule_item.destroy!
        end
        return render json: {status: 200, msg: 'success'}
      end
    rescue Exception => e
      return render json: {status: 500, msg: 'error'+e.to_s}
    end
  end

  def rule
    @rule_setting = Setting.where(var: 'mammon_prize_rule').first || Setting.new(var: 'mammon_prize_rule')
  end

  def save_rule
    @rule_setting = Setting.where(var: 'mammon_prize_rule').first
    if @rule_setting.blank?
      @rule_setting = Setting.create(var: 'mammon_prize_rule', value: params[:rule], memo: '财神开奖规则')
    else
      @rule_setting.update_attributes(value: params[:rule])
    end
    return redirect_to action: :rule
  end

  def give_code
    user = User.where(login_name: params[:mobile]).first
    @period.add_codes_to_user(user, params[:count].to_i) if user
    redirect_to mammon_periods_url, notice: '操作成功'
  end

  def give_card
    Mammon::UserCard.add_card_to_users([params[:mobile]]) if params[:mobile]
    redirect_to mammon_periods_url, notice: '操作成功'
  end

  def unlock
    user = User.where("login_name = ?", params[:mobile]).first if params[:mobile]
    if user
      $redis.expire("validation:#{user.id}", 1)
      flash[:success] = '解锁成功！'
    else
      flash[:danger] = '没有该用户！'  if params[:mobile]
    end
  end


  private

  def period_params
    params.require(:mammon_period).permit!
  end

  def set_period
    @period = Mammon::Period.find(params[:id]) if params[:id]
  end

end
