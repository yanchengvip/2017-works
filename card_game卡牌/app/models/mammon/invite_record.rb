class Mammon::InviteRecord < ApplicationRecord
  def self.first_invite_reg user_id,period_id
    record = Mammon::InviteRecord.find_by(:user_id => user_id,:period_id => period_id)
    record.blank? ? true : false
  end
end
