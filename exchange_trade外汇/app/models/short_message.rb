# ## Schema Information
#
# Table name: `short_messages` # 短信服务
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id()`**           | `integer`          | `not null, primary key`
# **`psz_sub_port(扩展子号)`**     | `string(255)`      | `default("*")`
# **`i_mobi_count(手机号码个数)`**       | `integer`          | `default(0)`
# **`psz_msg(短信内容，最大支持350个字)`**          | `text(65535)`      |
# **`psz_mobis(手机号码，用英文逗号(,)分隔，最大1000个号码)`**                       | `text(65535)`      |
# **`request_ip(ip地址)`**   | `string(255)`      | `default("")`
# **`channel_name(通道名)`**    | `string(255)`      | `default("梦网")`
# **`response_code(返回编码)`**      | `string(255)`      | `default("")`
# **`created_at()`**   | `datetime`         | `not null`
# **`updated_at()`**   | `datetime`         | `not null`
# **`pt_tmpl_id(语音模版编号)`**     | `string(255)`      |
# **`msg_type(消息类型1：语言验证码2：语音通知（文本语言）3：语音通知（语音id）)`**                                | `string(255)`      |
# **`is_voice(是否语音验证码)`**    | `boolean`          | `default(FALSE)`
#
# ### Indexes
#
# * `index_messages_on_request_ip`:
#     * **`request_ip`**
#

class ShortMessage < ApplicationRecord
  MW = {
    password: "185247",
    userid: "JI1153",
    submit_url: "http://101.251.214.153:8901/MWGate/wmgw.asmx",
  }
  MWVOICE = {
    password: "651232",
    userid: "YY0205",
    submit_url: "http://61.145.229.28:5001/voiceprepose",
    pt_tmpl_id: "200047",
  }
  #短信接口
  # @param [string] phone 用户手机号
  # @param [string] request_ip 用户ip
  # @param [boolean] is_voice 是否发送语音验证码
  # @param [string] pre 前缀
  # @return (<ShortMessage> or false)
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.send_verification_code(phone, request_ip, is_voice = false, pre = nil )
    send_message_count = $redis.incrby("send_message_count_#{phone}", 1)
    ip_send_message_count = $redis.incrby("ip_send_message_count_#{request_ip}", 1)
    $redis.expire("send_message_count_#{phone}", 24 * 3600)
    $redis.expire("ip_send_message_count_#{request_ip}", 24 * 3600)
    if send_message_count < 10 && ip_send_message_count < 50
      code = "%06d" % rand(999999)
      if Setting.test
        code = "111111"
      end
      if pre
        Rails.cache.write("#{pre}_#{phone}", code, 5 * 60)
      else
        Rails.cache.write(phone, code, expire_time: 5 * 60) #短信验证码有效期10分钟
      end
      #暂时全部发送语音验证码
      # is_voice = true
      unless is_voice
        ShortMessage.create(psz_mobis: phone, psz_msg: "您好，感谢关注钻联科技，您的手机验证码是：#{code}，请妥善保管！", i_mobi_count: 1, request_ip: request_ip, is_voice: false)
      else
        ShortMessage.create(psz_mobis: phone, psz_msg:  code, i_mobi_count: 1, request_ip: request_ip, is_voice: true, psz_sub_port: "125909888778")
      end
    else
      return false
    end
  end

  after_create :send_message
  private
  def send_message
    conn = Faraday.new
    unless self.is_voice
      res = conn.post(ShortMessage::MW[:submit_url]+"/MongateSendSubmit", {userId: ShortMessage::MW[:userid],
        password: ShortMessage::MW[:password],
        pszMobis: self.psz_mobis,
        pszMsg: self.psz_msg,
        iMobiCount: self.i_mobi_count,
        pszSubPort: self.psz_sub_port,
        MsgId: self.id,
      })
    else
      res = conn.post(ShortMessage::MWVOICE[:submit_url]+"/MongateSendSubmit", {userId: ShortMessage::MWVOICE[:userid],
        password: ShortMessage::MWVOICE[:password],
        pszMobis: self.psz_mobis,
        pszMsg: self.psz_msg,
        iMobiCount: self.i_mobi_count,
        pszSubPort: self.psz_sub_port,
        MsgId: self.id,
        PtTmplId: ShortMessage::MWVOICE[:pt_tmpl_id],
        msgType: "1"
      })
    end
    Rails.logger.info(res.body)
    doc =  REXML::Document.new(res.body)
    self.update(response_code: doc.root.text)
  end
end
