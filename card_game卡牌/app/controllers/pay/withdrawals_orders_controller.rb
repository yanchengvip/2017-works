require 'csv'
class Pay::WithdrawalsOrdersController < ApplicationController
  before_action :set_pay_withdrawals_order, only: [:show, :complete, :cancel]
  skip_before_action :verify_authenticity_token, only: [:complete, :cancel]
  before_action :side_menus11

  def index
    @q = Pay::WithdrawalsOrder.active.ransack(params[:q])
    @pay_withdrawals_orders = @q.result.page(params[:page]).per(20)

    if request.format.symbol == :csv
      csv_data = "\xEF\xBB\xBF" + CSV.generate do |csv|
        csv << %W(提现时间 订单号 支付宝账单号 用户手机 用户昵称 提现金额 提现状态)
        @q.result.each do |order|
          csv << [order.pay_date&.strftime("%Y-%m-%d %H:%M"), order.identifier, order.alipay_order_id, order.user&.mobile, order.user&.nick_name, order.amount, Pay::WithdrawalsOrder::STATUS[order.status]]
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv { render text: csv_data }
    end
  end


  #提现记录
  def withdraw_cash
    if params[:pay_date]
      @start_date = params[:pay_date]
      end_date = (Date.parse(params[:pay_date] + "-01 00:00:00") + 1.month).strftime('%Y-%m')
    else
      @start_date = Time.now.strftime('%Y-%m')
      end_date = (Time.now + 1.month).strftime('%Y-%m')
    end
    @pay_withdrawals_orders = Pay::WithdrawalsOrder.select("sum(amount) as amount,count(*) as count").where("pay_date >= '#{@start_date}' and pay_date<= '#{end_date}'")
  end


  #确认充值
  def complete
    render json: '接口暂时停用' #使用时取消此行代码即可
    begin
      if ['cancel', 'transfer'].include?(@order.status)
        user = User.includes(:account_ticket).find(@order.user_id)
        alipay_params ={out_biz_no: @order.identifier, amount: @order.real_amount, payee_account: user.account_ticket&.alipay_account}
        res = Pay::WithdrawalsOrder.alipay_transfer alipay_params
        if res['code'] == '10000' && res['out_biz_no'] == @order.identifier
          @order.update_attributes(status: 'complete', alipay_order_id: res['order_id'], pay_date: res['pay_date'], content: res)
          flag = '充值成功!'
        else
          flag = "充值失败,订单状态不符合条件!#{res}"
        end
      end
    rescue Exception => e
      Rails.logger.info(e.as_json)
      flag ="充值失败!#{e.as_json}"
    end
    flash['success'] = flag
    redirect_to pay_withdrawals_orders_path
  end


  #作废订单

  def cancel
    render json: '接口暂时停用' #使用时取消此行代码即可

    flag = '作废订单失败!'
    if @order.status == 'transfer'
      @order.update_attributes(status: 'cancel')
      flag = '作废订单成功!'
    end
    flash['success'] = flag
    redirect_to pay_withdrawals_orders_path
  end


  private


  def set_pay_withdrawals_order
    @order = Pay::WithdrawalsOrder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def pay_withdrawals_order_params
    params.require(:pay_withdrawals_order).permit(:amount, :amount, :user_id, :status, :admin_id, :identifier, :content, :remark, :order_id, :pay_date)
  end
end
