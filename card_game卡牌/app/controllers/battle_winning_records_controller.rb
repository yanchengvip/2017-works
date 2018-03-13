class BattleWinningRecordsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update]
  before_action :side_menus1
  before_action :side_menus6, only: [:csv_index]
  before_action :set_battle_winning_record,only: [:show,:edit]
  before_action :set_battle_winning_record, only: [:show, :edit]
  before_action :set_battle_failure_record, only: [:fail_order_show, :fail_order_edit]
  skip_before_action :verify_authenticity_token, only: [:destroy, :update]

  def index
    if params[:order_type].to_i == 1
      #战役失败用户补差价获得商品订单列表
      @order_type = 1
      @battle_orders = BattleWinningRecord.show_index params, 'BattleFailureRecord'
    else
      #战役胜利获得订单
      @order_type = 2
      @battle_orders = BattleWinningRecord.show_index params, 'BattleWinningRecord'
    end

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(赛场ID 赛场名称 夺宝期号 中奖时间 中奖商品 用户手机 用户昵称 认领状态 订单状态)
        @battle_orders.each do |order|
          csv << [order.battle_id, order.battle_name, order.battle_code, order.create_time&.strftime("%Y-%m-%d %H:%M"), order.good_name, order.user&.mobile? ? order.user&.mobile : '无', order.user&.present? ? order.user&.nick_name : '无', order.claim_status, order.shipping_status]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end

  end

  def csv_index
    index
  end

  def show

  end

  def edit

  end

  def update
    if params[:order_type].to_i == 1
      order = BattleFailureRecord.find(params[:id])
    else
      order = BattleWinningRecord.find(params[:id])
    end
    if order.claim_status != 2
      flash[:success] = '未认领的订单不能修改！'
      redirect_to "/battle_winning_records/#{order.id}/edit" and return
    end
    order.update_attributes!(order_params)
    if params[:shipping_status].to_i != 3 && order.shipping_status == 2
      flash[:success] = '已换功勋只能修改作废！'
      redirect_to "/battle_winning_records/#{order.id}/edit" and return
    end
    if [1, 3].include?(params[:shipping_status].to_i) && order.shipping_status != 3
      order.update_attributes(shipping_status: params[:shipping_status])
    end
    flash[:success] = '修改成功！'
    if params[:order_type].to_i == 1
      redirect_to "/battle_winning_records/fail_order_edit?id=#{order.id}" and return
    else
      redirect_to "/battle_winning_records/#{order.id}/edit" and return
    end

  end



  #失败后用户补差价兑换的商品订单
  def fail_order_show

  end

  def fail_order_edit

  end


  private

  def set_battle_winning_record
    @order = BattleWinningRecord.includes(:user, :battle, :battle_products_copies, :battle_packages).find(params[:id])
  end

  def set_battle_failure_record
    @order = BattleFailureRecord.includes(:user, :battle, :battle_products_copies, :battle_packages).find(params[:id])
  end
  def order_params
    params.permit(:shipping_time, :shipping_name, :logistics_company, :logistics_num)
  end
end
