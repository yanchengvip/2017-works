module RechargeHelper
  extend ActiveSupport::Concern
  module ClassMethods
    def phone_post options = {}
      con = RestClient.post(SYSTEMCONFIG['huyi']['host'], options)
      result = JSON.parse(con.body)
    end
  end

  module InstanceMethods

    def order_params time_str
      return params = {
        action: 'recharge',
        username: SYSTEMCONFIG['huyi']['api_id'],
        mobile: self.number,
        package: self.amount,
        orderid: self.code,
        timestamp: time_str
      }
    end

    def order_sign_str time_str
      return Digest::MD5.hexdigest("apikey=#{SYSTEMCONFIG['huyi']['api_key']}&mobile=#{self.number}&orderid=#{self.code}&package=#{self.amount}&timestamp=#{time_str}&username=#{SYSTEMCONFIG['huyi']['api_id']}")
    end

    def confirm_params time_str
      return params = {
        action: 'getorderinfo',
        orderid: self.code,
        username: SYSTEMCONFIG['huyi']['api_id'],
        timestamp: time_str
      }
    end

    def confirm_sign_str time_str
      return Digest::MD5.hexdigest("apikey=#{SYSTEMCONFIG['huyi']['api_key']}&orderid=#{self.code}&timestamp=#{time_str}&username=#{SYSTEMCONFIG['huyi']['api_id']}")
    end

  end

  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
end
