class Admin < ApplicationRecord
  validates :nickname, uniqueness: { scope: :delete_flag, message: "登录名不能重复"}
  validates :phone, uniqueness: { scope: :delete_flag, message: "手机号不能重复"}
  validates :phone, presence: true

  has_many :admin_roles, -> {where(delete_flag: false)}, dependent: :destroy
  has_many :roles, through: :admin_roles
  has_many :authority_resources,through: :roles
  before_create :encrypt_password
  before_update :check_password_change

  #用户登录
  def self.login(login_name, password)
    # if login_name.match(/^1\d{10}$/)
    #   admin = Admin.where(phone: login_name).first
    # else
    #   admin = Admin.where(nickname: login_name).first
    # end
    admin = Admin.where(phone: login_name).first
    unless admin.present?
      admin = Admin.where(nickname: login_name).first
    end

    if admin && (Digest::SHA1.hexdigest(password + admin.salt) == admin.encrypted_password)
      return admin
    else
      return nil
    end
  end

  #生成用户密码
  def encrypt_password
    if encrypted_password
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("")
      self.encrypted_password = Digest::SHA1.hexdigest(self.encrypted_password+self.salt)
    end
  end

  #更改用户密码
  def check_password_change
    if self.encrypted_password_change
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("") if self.salt.nil?
      self.encrypted_password = Digest::SHA1.hexdigest(self.encrypted_password+self.salt)
    end
  end

  #后台修改用户密码验证
  def valid_current_password password
    if Digest::SHA1.hexdigest(password+self.salt) == self.encrypted_password
      return true
    else
      return false
    end

  end

  def is_admin?
    admin_role = roles.active.map(&:id)
    return admin_role.present?
  end

  # 拥有角色名称
  def role_names
    roles.active.map(&:name).join('，')
  end

  def in_use?
    self.delete_flag ? false : true
  end

  def is_super?
    roles.active.map(&:name).include?('超级管理员')
  end

  def check_roles(role_ids)
    rids = self.roles.map(&:id)
    role_ids && role_ids.each do |rid|
      if !rids.include?(rid.to_i)
        if admin_role = AdminRole.find_by(admin_id: self.id, role_id: rid.to_i)
          admin_role.update_attributes!(delete_flag: false)
        else
          self.roles << Role.find(rid)
        end
      end
    end
    rids && rids.each do |rid|
      if !role_ids.include?(rid.to_s)
        AdminRole.active.find_by(admin_id: self.id, role_id: rid)&.destroy
      end
    end
  end


end
