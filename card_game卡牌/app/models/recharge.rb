class Recharge < ApplicationRecord
  belongs_to :table, polymorphic: true
  belongs_to :user
  belongs_to :admin
  include RechargeHelper

  validates :code, uniqueness: { scope: :delete_flag, message: "订单号不能重复"}
  RECHARGE_TYPE = {1 => '手机充值', 2 => 'Q币充值'}
  STATUS = {-1 => '取消充值', 0 => '待充值', 1 => '充值中', 2 => '充值成功', 3 => '充值失败'}

  def order!(admin_id)
    res = {status: false, msg: '充值失败！', data: {huyi_code: ''}}
    time_str = Time.now.strftime("%Y%m%d%H%M%S")
    params = self.order_params time_str
    sign_str = self.order_sign_str time_str

    begin
      Timeout.timeout(120) do
        self.with_lock do
          if self.recharge_type == 1
            result = Recharge.phone_post(params.merge(sign: sign_str))
            if result['code'] == 1
              res = {status: true, msg: result['message'], data: {huyi_code: result['taskid']}}
              self.update_attributes!(status: 1, admin_id: admin_id, huyi_code: res[:data][:huyi_code], memo: res[:msg], order_time: time_str)
            else
              res = {status: false, msg: result['code'].to_s + '&' + result['message'], data: {huyi_code: ''}}
            end
          elsif self.recharge_type == 2
          end
        end
      end
    rescue Exception => e
      p e.to_s
      res[:msg] += e.to_s
    end

    res
  end

  def self.confirm_status!
    Recharge.active.where(status: 1).find_each do |r|
      r.confirm_status!
    end
  end

  def confirm_status!
    time_str = Time.now.strftime("%Y%m%d%H%M%S")
    params = self.confirm_params time_str
    sign_str = self.confirm_sign_str time_str

    begin
      Timeout.timeout(120) do
          if self.recharge_type == 1
            result = Recharge.phone_post(params.merge(sign: sign_str))
            if result['code'] == 1 && result['orderid'] == self.code && result['status'] == 2
              self.update_attributes!(status: 2)
              self.table.update_attributes(status: 2)
            elsif result['code'] == 1 && result['orderid'] == self.code && result['status'] == 3
              self.update_attributes!(status: 3)
            end
          elsif self.recharge_type == 2
          end
      end
    rescue Exception => e
      p e.to_s
    end
  end


end
