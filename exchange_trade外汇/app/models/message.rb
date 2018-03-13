# ## Schema Information
#
# Table name: `messages` # 消息表
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id()`**          | `integer`          | `not null, primary key`
# **`msg_type(类型1 系统发布通知 2 交易消息,建仓消息 3 交易消息, 关注交易信息 4交易消息,平仓结算消息 5交易消息,,用户跟随交易信息 6图文发布关注信息,点赞 7图文发布关注,信息评论)`**                                                                                          | `integer`          | `default(0)`
# **`body(通知内容)`**    | `text(65535)`      |
# **`user_ids(用户id列表 all 时推送所有人)`**               | `text(65535)`      |
# **`active(软删除字段)`**  | `boolean`          | `default(TRUE)`
# **`created_at()`**  | `datetime`         | `not null`
# **`updated_at()`**  | `datetime`         | `not null`
# **`from_user_id(产生消息 用户id)`**           | `integer`          |
# **`title(消息标题)`**   | `string(255)`      |
# **`percent(保证金百分数/报警使用)`**        | `decimal(16, 6)`   | `default(0.0)`
#

class Message < ApplicationRecord
  belongs_to :from_user, optional: true, foreign_key: "from_user_id", class_name: "User"
  self.xml_options = {
    :only => ["id", "msg_type", "body", "user_ids", "created_at"].freeze,
    :include => {
      :from_user => { :only => ["nickname", "headimgurl", ].freeze}
    }
  }
  def do_jpush
    jpush = JPush::Client.new(Setting.jpush["app_key"], Setting.jpush["master_secret"])
    pusher = jpush.pusher

    if self.user_ids == 'all'
      push_payload = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: 'all',
        notification: '新消息通知',
        message: self.body,
      ).set_options({apns_production: Setting.jpush["apns_production"]})
      pusher.push(push_payload)
    else
      alis = self.user_ids.split(",")
      audience = JPush::Push::Audience.new
      # audience.set_registration_id(registration_ids)
      audience.set_alias(alis)
      push_payload = JPush::Push::PushPayload.new(
        platform: 'all',
        audience: audience,
        notification: '新消息通知',
        message: self.body,
      ).set_options({apns_production: Setting.jpush["apns_production"]})
      pusher.push(push_payload)
    end
  end
end
