# game_jackpot
class InviteRelationship < ApplicationRecord
  self.table_name = 'invite_relationship'

  def self.sny_relation
    conn = Faraday.new
    InviteRelationship.where(status: 0, flag: 0).each do |x|
      conn.get("#{ALIPAYCONFIG[:alipay][:host]}/api/mammon/invite_records/invitation_registered?invite_id=#{x.invite_user_id}&invite_user_id=#{x.cover_invite_user_id}")
    end
  end
end
