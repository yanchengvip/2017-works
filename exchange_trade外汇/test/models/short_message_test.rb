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

require 'test_helper'

class ShortMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
