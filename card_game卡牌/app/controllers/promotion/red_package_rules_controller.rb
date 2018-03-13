class Promotion::RedPackageRulesController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_action :side_menus11
  before_action :set_red_package_rule
  # skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    @q = Promotion::RedPackageRule.active.ransack(params[:q])
    @red_package_rules = @q.result.includes(:red_package_rule_items).page(params[:page]).per(15)
  end

  def show
    @rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 1)
    @voucher_rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 2)
    @bxf_rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 3)
  end

  def new
    @red_package_rule = Promotion::RedPackageRule.new
  end

  def create
    @red_package_rule = Promotion::RedPackageRule.new(red_package_rule_params.merge(admin_id: current_user.id))
    begin
      ActiveRecord::Base.transaction do
        if @red_package_rule.save!
          @red_package_rule.save_items!(params[:rule_items], params[:voucher_rule_items], params[:bxf_rule_items])
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
    @rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 1)
    @voucher_rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 2)
    @bxf_rule_items = @red_package_rule.red_package_rule_items.where(prize_type: 3)
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @red_package_rule.update_attributes!(red_package_rule_params.merge(admin_id: current_user.id))
          @red_package_rule.save_items!(params[:rule_items], params[:voucher_rule_items], params[:bxf_rule_items])
        end
        flash[:success] = '修改成功！'
        return redirect_to action: :index
      end
    rescue Exception => e
      flash[:danger] = '修改失败！' + e.to_s
      return render action: :edit, id: @red_package_rule.id
    end
  end

  def shelf
    begin
      if @red_package_rule.update_attributes!(status: params[:shelf_status])
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
        if rule_item = Promotion::RedPackageRuleItem.find_by(id: params[:rule_item_id].to_i)
          rule_item.destroy!
        end
          # @red_package_rule.update_total! rule_item.amount * rule_item.count
        return render json: {status: 200, msg: 'success'}
      end
    rescue Exception => e
      return render json: {status: 500, msg: 'error'+e.to_s}
    end
  end


  private

  def red_package_rule_params
    params.require(:promotion_red_package_rule).permit!
  end

  def set_red_package_rule
    @red_package_rule = Promotion::RedPackageRule.find(params[:id]) if params[:id]
  end

end
