class MallOrder < ApplicationRecord
  belongs_to :user
  belongs_to :battle_product
  belongs_to :address, class_name: 'Address', foreign_key: :address_id
  STATUS={-1=>'已作废' ,0 => '未领取', 1 => '待发货', 2 => '已发货'} #订单状态
  PAYTYPE={1 => '无支付', 2 => '功勋', 3 => '微集分'} #订单通兑方式
  POSTAGEPAYSTATUS={0 => '待支付', 1 => '已支付'} #运费支付状态
  ORDER_TYPE={1 => '平台赛场订单', 2 => '自建赛场订单', 3 => '兑奖阁订单'}
  include DownloadCsv
  include CsvDataHelper
  has_one :recharge, as: :table
  RECEIVE_STATUS={-1=>'已作废' ,0 => '未领取', 1 => '待领取', 2 => '已领取'}
  has_one :battle_winning_record, foreign_key: :battle_id, primary_key: :battle_id


  #奇珍商城订单列表
  def self.show_index params
    joins = []
    conditions = []
    values = []
    if params[:product_name].present?
      conditions << 'product_name like ?'
      values << "%#{params[:product_name]}%"
    end
    if params[:created_at_begin].present?
      conditions << 'created_at >= ?'
      values << params[:created_at_begin]
    end
    if params[:created_at_end].present?
      conditions << 'created_at <= ?'
      values << params[:created_at_end]
    end
    if params[:status].present? && params[:status].to_i != -2
      conditions << 'status = ?'
      values << params[:status]
    end
    if params[:mobile].present?
      joins << 'left join user as user on user.id = mall_order.user_id'
      conditions << 'user.mobile like ?'
      values << "%#{params[:mobile]}%"
    end
    @mall_orders = MallOrder.joins(joins.join(' ')).where(conditions.join(' and '),*values)
                       .active.order('created_at desc').page(params[:page].to_i).per(20)
  end

  def pay_num
    res = '无支付'
    case self.pay_type
    when 1
      res = self.glory
    when 2
      res = self.micro_score
    end
    return res
  end

  def self.export_excel(results)
    require 'csv'
    CSV.generate(:col_sep => "\t", :row_sep => "\r\n") do |csv|
      csv << ['赛场ID','幸运号码', '兑换时间', '商品名称', '商品ID', '商品价格',' 商品链接', '支付方式' ,'支付金额', '用户昵称', '用户手机号', '收货姓名', '收货电话', '收货地址']
      results.each_with_index do |r, index|
        csv << [r.battle_id, r.lucky_code, r.created_at.strftime("%Y-%m-%d %H:%m:%S"), r.product_name, r.battle_product_id, r.market_price, r.battle_product&.detail_url, MallOrder::PAYTYPE[r.pay_type], r.pay_num, r.user&.nick_name, r.user&.mobile, r.consignee, r.mobile, r.shipping_address]
      end
    end.encode('gb2312', :invalid => :replace, :undef => :replace, :replace => "?")
  end

  def get_recharge_record! admin_id, confirm_status
    recharge = self.recharge
    if recharge.blank? && self.battle_product&.product_type == 1
      recharge = Recharge.create!(
        code: "mall_order_#{self.id}",
        recharge_type: 1,
        number: self.user&.mobile,
        amount: self.battle_product.product_num,
        user_id: self.user_id,
        admin_id: admin_id,
        table_id: self.id,
        table_type: 'MallOrder',
        status: confirm_status == 1 ? 0 : -1,
        channel: self.order_type
      )
    end
    recharge
  end

end
