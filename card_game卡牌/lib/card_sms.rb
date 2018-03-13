require 'rexml/document'
module CardSms
  def self.send_message phone,content,msg_id=1
    conn = Faraday.new
    res = conn.post(SYSTEMCONFIG["sms"]["mw"]["submit_url"]+"/MongateSendSubmit", {
        userId: SYSTEMCONFIG["sms"]["mw"]["userid"],
        password: SYSTEMCONFIG["sms"]["mw"]["password"],
        pszMobis: phone,
        pszMsg: content,
        iMobiCount: phone.split(',').length,
        pszSubPort: '*',
        MsgId: msg_id,
    })
    doc = REXML::Document.new(res.body)
    success = doc.root.text.size >= 15
  end
end
