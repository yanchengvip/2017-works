module SendVoucherToIhave
  module ClassMethods

  end

  module InstanceMethods
    def send_voucher_to_ihaveu
      res = false
      if self.voucher_prizes_status == 1
        ihaveu_login_name = self.user.ihaveu_login_name
        self.with_lock do
          self.update!(voucher_prizes_status: 3)
          chest_prize_items =  ChestPrize.get_prizes_by_ids(self.chest_prize_ids)

          event_ids = chest_prize_items.select{|x| x["prize_type"] == 6}.map{|x| x["event_id"]}
          rsa_private_key = SYSTEMCONFIG[:ihaveu][:rsa_private_key]
          params = {
            id: event_ids.join(","),
            login: ihaveu_login_name,
            timestamp: Time.now.to_s,
          }
          params[:sign] = rsa_private_sign("id=#{params[:id]}&login=#{params[:login]}&timestamp=#{params[:timestamp]}", rsa_private_key)
          res = Faraday.new.post(SYSTEMCONFIG[:ihaveu][:host] + "/auction/events/create_voucher", params).body
        end
        return res
      else
        return false
      end
    end

    def rsa_private_sign(data, private_key)
      pri = OpenSSL::PKey::RSA.new(Base64.decode64 private_key)
      sign = pri.sign('sha1', data.force_encoding("utf-8"))
      signature = Base64.encode64(sign)
      signature = signature.delete("\n").delete("\r")
      return signature
    end
  end

  # params[:sign] && params[:id] && params[:login] && params[:timestamp] && Auction::VoucherTrade.rsa_verify("id=#{params[:id]}&login=#{params[:login]}&timestamp=#{params[:timestamp]}", params[:sign], SYSCONFIG["treasure_service"]["rsa_pub_key"])
  #     if (event = Auction::Event.active.published.unexpired.where(id: params[:id]).first) && params[:login] && account = Core::Account.search_by_params(login: params[:login])

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
