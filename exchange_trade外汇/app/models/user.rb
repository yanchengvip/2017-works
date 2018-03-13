# ## Schema Information
#
# Table name: `users` # 用户表
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id()`**             | `integer`          | `not null, primary key`
# **`nickname(用户名)`**    | `string(255)`      |
# **`phone(手机号)`**       | `string(255)`      |
# **`password_digest(密码)`**    | `string(255)`      |
# **`status(状态;1:启用,2:禁用)`**     | `integer`          | `default(1)`
# **`salt(加密随机码)`**      | `string(255)`      |
# **`headimgurl(头像)`**   | `string(255)`      |
# **`last_login_time(最后一次登录时间)`**          | `datetime`         |
# **`login_device(登录设备)`**   | `string(255)`      |
# **`token(登录token)`**   | `string(255)`      |
# **`is_agree(是否同意协议)`**  | `boolean`          | `default(TRUE)`
# **`expire_time(token过期时间)`**       | `datetime`         |
# **`request_ip(登录ip地址)`**   | `string(255)`      |
# **`active(软删)`**       | `boolean`          | `default(TRUE)`
# **`created_at()`**     | `datetime`         | `not null`
# **`updated_at()`**     | `datetime`         | `not null`
# **`pay_password(支付密码)`**   | `string(255)`      |
# **`sex(性别 0 未知 1男 2女)`**   | `integer`          | `default(0)`
# **`birthday(生日)`**     | `datetime`         |
# **`desc(简介)`**         | `string(50)`       |
# **`email(邮箱)`**        | `string(255)`      |
# **`area(地区)`**         | `string(255)`      |
#
# ### Indexes
#
# * `index_users_on_nickname`:
#     * **`nickname`**
# * `index_users_on_phone` (_unique_):
#     * **`phone`**
# * `index_users_on_token` (_unique_):
#     * **`token`**
#

class User < ApplicationRecord
  before_create :encrypt_password
  before_update :check_password_change
  before_update :check_pay_password_change
  validates :sex, inclusion: { in: [0, 1, 2]}
  validates :desc, length:{in: 0..50,message:'must in 0-50 byte'}, allow_nil: true
  validates :nickname, length:{in: 0..20,message:'must in 0-20 byte'}, allow_nil: true
  validates :phone, uniqueness: true, allow_nil: true
  mount_uploader :headimgurl, HeadimgurlUploader
  has_many :accounts
  action_store :like, :article, counter_cache: true
  action_store :like, :comment, counter_cache: true

  self.xml_options = {
    :only => ["id", "nickname", "phone", "status", "headimgurl", "last_login_time", "login_device", "token", "is_agree", "expire_time", "request_ip", "active", "created_at", "updated_at", "sex", "birthday", "desc", "email", "area"].freeze,
  }

  #生成用户密码
  # @param [string] password 密码
  # @return (<User> or false)
  # @author wangxia <xia.wang01@ihaveu.net>
  def encrypt_password
    if password_digest
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("")
      self.password_digest = Digest::SHA1.hexdigest(self.password_digest+self.salt)
    end
  end

  #更改用户密码
  # @param [string] password 密码
  # @return (<User> or false)
  # @author wangxia <xia.wang01@ihaveu.net>更改用户密码
  def check_password_change
    if self.password_digest_change
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("") if self.salt.nil?
      self.password_digest = Digest::SHA1.hexdigest(self.password_digest+self.salt)
    end
  end


  #更改用户支付密码
  # @param [string] password 密码
  # @return (<User> or false)
  # @author wangxia <xia.wang01@ihaveu.net>更改用户密码
  def check_pay_password_change
    if self.pay_password_change
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("") if self.salt.nil?
      self.pay_password = Digest::SHA1.hexdigest(self.pay_password+self.salt)
    end
  end

  #验证密码
  # @param [string] password 密码
  # @return (true or false)
  # @author wangxia <xia.wang01@ihaveu.net>验证密码
  def verify_password(password)
    if Digest::SHA1.hexdigest(password+self.salt) == self.password_digest
      return true
    else
      return false
    end
  end


  #验证支付密码
  # @param [string] pay_password 支付密码
  # @return (true or false)
  # @author wangxia <xia.wang01@ihaveu.net>验证支付密码
  def verify_pay_password(password)
    if Digest::SHA1.hexdigest(password+self.salt) == self.pay_password
      return true
    else
      return false
    end
  end

  #登陆后写入设备信息
  def login(request)
    generate_authentication_token
    self.expire_time = Time.now + Setting.token_expire_time.to_i
    self.last_login_time = Time.now
    self.login_device = request.headers["HTTP_DEVICE"]
    self.request_ip = request.remote_ip
    self.save!
  end

  #生成用户auth token
  def generate_authentication_token
    loop do
      self.token = SecureRandom.base64(64)
      break if !User.find_by(token: token)
    end
  end

end
