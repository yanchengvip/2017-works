class User < ApplicationRecord
  self.table_name = 'user'
  SEX = {0 => '男', 1 => '女'}
  include UserDataHelper
  include DownloadCsv

  has_many :user_third_partys, -> { where(delete_flag: false) }, class_name: 'UserThirdParty', foreign_key: 'third_account', primary_key: 'mobile'
  has_many :battle_user_records

  has_one :account_ticket
  has_many :account_ticket_details
  has_many :chest_records
  has_many :chest_record_items
  has_many :user_login_records, class_name: 'UserLoginRecord'
  has_many :card_user_third_parties
  has_many :pay_withdrawals_orders, :class_name => 'Pay::WithdrawalsOrder',foreign_key: :user_id
  has_many :account_ticket_balance_details,foreign_key: :user_id
  has_many :mammon_user_winnings, :class_name => 'Mammon::UserWinning'

  # 是否绑定手机号
  def is_binding_mobile?
    self.login_name && self.login_name[0..4] != '10000'
  end
  #新用户 = 本周注册用户
  def is_new_user?
    create_time > Time.now.at_beginning_of_week
  end

  #活跃用户 新用户 = 本周赛1场  老用户 = 本周赛3场
  def is_active_user?
    battle_count = self.get_battle_count
    if is_new_user?
      battle_count >= Setting.value("new_user_play_count").to_f
    else
      battle_count >= Setting.value("old_user_play_count").to_f
    end
  end

  #获取用户的活跃规则定义的 参赛场次
  def get_battle_count
    battle_count = BattleUserRecord.joins('left join game_battle_record as b on b.id = battle_user_record.battle_id').joins('left join game_types as c on c.id = b.game_types_id').where("battle_user_record.create_time > ?  and battle_user_record.user_id = ? and c.is_ai=0", get_battle_time, self.id).count
  end

  #获取参赛用户是 参赛场次计算的 开始时间
  def get_battle_time
    if Setting.value("active_type") == '2' #周
      Time.now.at_beginning_of_week - (Setting.value("active_value").to_i - 1) * 604800 # 3600 * 24 * 7
    else
      Time.now.at_beginning_of_day - (Setting.value("active_value").to_i - 1) * 86400 # 3600 * 24
    end
  end

  def app_logined?
    ulr = UserLoginRecord.where("user_id = ? and login_type in ('ios', 'android')", self.id).limit(1)
    return ulr.blank? ? '否' : '是'
  end

  #根据drp获取用户优众网登陆账号
  def ihaveu_login_name
    drp_user = DrpUser.where(login_name: self.login_name, delete_flag: 0).last
    UserThirdParty.where(user_id: drp_user.user_id, delete_flag: 0, type: 1).last&.third_account
  end

end
