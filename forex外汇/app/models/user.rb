class User < ApplicationRecord
  validates :sex, inclusion: {in: [0, 1, 2]}
  validates :nickname, length: {in: 0..14, message: 'must in 0-14 byte'}, allow_nil: true
  validates :phone, uniqueness: true
  validates :token, uniqueness: true
  before_create :encrypt_password
  after_save :encrypt_password if Proc.new { |user| user.password_changed? }
  after_create :create_virtual_account
  has_many :accounts



  #登陆后写入设备信息
  def login_update(request)
    generate_authentication_token
    self.token_time = Time.now + 604800 # 7 * 24 * 3600
    self.login_time = Time.now
    self.login_device = request.headers["HTTP_DEVICE"]
    self.login_ip = request.remote_ip
    self.save!
  end

  #生成用户auth token
  def generate_authentication_token
    self.token = SecureRandom.urlsafe_base64
  end


  #生成用户密码
  def encrypt_password
    if self.password
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("")
      self.password = Digest::SHA1.hexdigest(self.password+self.salt)
    end
  end

  #验证密码
  def verify_password(password)
    if Digest::SHA1.hexdigest(password+self.salt) == self.password
      return true
    else
      return false
    end
  end

  class << self
    #发送短信
    def send_sms key, phone
      return {status: 500, msg: '验证码已经发，请稍后再试', data: {}} if Rails.cache.exist?(key)
      #每天同一个手机号最多为10条
      send_message_count = $redis.incrby("send_sms_count_#{phone}", 1)
      $redis.expire("send_sms_count_#{phone}", (Time.now.end_of_day - Time.now).to_i)
      if send_message_count <= 10
        code = MyUtils.generate_num_random
        ForexSms.send_message(phone, "您的验证码为【#{code}】有效期5分钟")
        Rails.cache.write(key, code, expires_in: 5 * 60) #短信验证码有效期5分钟
        return {status: 200, msg: '发送成功', data: {}}
      else
        return {status: 501, msg: '每天最多发送十条，已经超过限制', data: {}}
      end

    end

  end


  private

  #创建虚拟账户
  def create_virtual_account
    #获取虚拟券商
    dealer = Dealer.where(dealer_type: 1).first
    self.accounts.create(name: self.nickname, phone: self.phone, status: 1, typee: 1, dealer_id: dealer&.id, dealer_type: 1, leverage: 1, balance: 100000, margin_free: 100000, equity: 100000)
  end


end
