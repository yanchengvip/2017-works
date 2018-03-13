class Mammon::UserCode < ApplicationRecord
  belongs_to :attack_user, class_name: 'User', foreign_key: "attack_user_id"
    self.xml_options = {
        :only => ["id", "user_id", "period_id", "codes", "count", "attack_user_id", "source_type", "delete_flag", "created_at", "updated_at"].freeze,
        include: {
          attack_user: {
            :only => ["id", "nick_name", "login_name", "head_url", "name"]
          }
        }
    }.freeze

  def self.add_code invite_id,period,user, code_count = 5
    pop_code = period.pop_code code_count
    period.add_user_codes(user, pop_code)
    # pop_code.each do |index|
    self.create(:user_id => invite_id,:period_id => period.id,:codes => pop_code.join(','),:count => pop_code.size,:source_type => 4)
    # end
  end
end
