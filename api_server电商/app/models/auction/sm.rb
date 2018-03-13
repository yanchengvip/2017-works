class Auction::Sm < ApplicationRecord
  self.table_name = 'auction_smss'
  after_create :send_message

  private
  def send_message
    conn = Faraday.new
    case Setting.sms['type']
      when 'mw'
        res = conn.post(Setting.sms["mw"]["submit_url"]+"/MongateSendSubmit", {
            userId: Setting.sms["mw"]["userid"],
            password: Setting.sms["mw"]["password"],
            pszMobis: self.phone,
            pszMsg: self.content,
            iMobiCount: '1',
            pszSubPort: '*',
            MsgId: self.id,
        })
        doc = REXML::Document.new(res.body)
        success = doc.root.text.size >= 15
      when 'yunpian'
        res = conn.post(Setting.sms['yunpian']['single_url'], {
            apikey: Setting.sms['yunpian']['apikey'],
            mobile: self.phone,
            text: Setting.sms['yunpian']['sign'] + self.content
        })
        success = JSON.parse(res.body)['code'] == 0
    end
    Rails.logger.info(res.body)
    self.update(success: success, :send_at => Time.now)
  end

end
