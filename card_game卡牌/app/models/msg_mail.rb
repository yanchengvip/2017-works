class MsgMail < ApplicationRecord
  self.table_name = 'msg_mail'
  belongs_to :mail_type, class_name: 'MailType', foreign_key: 'mail_type_id'
end
