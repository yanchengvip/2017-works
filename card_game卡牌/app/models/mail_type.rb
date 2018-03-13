class MailType < ApplicationRecord
  self.table_name = 'msg_mail_type'

  CATEGORY = {1 => '普通', 2 => '有奖励'}
end
