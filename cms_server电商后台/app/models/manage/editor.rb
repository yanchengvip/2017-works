class Manage::Editor < ApplicationRecord
  has_many :editor_role_relationships, ->{where(active: true)}, dependent: :destroy
  has_many :roles, ->{where(active: true)},  through: :editor_role_relationships
  has_many :authorities, ->{where(active: true)}, through: :roles
  before_create :encrypt_password
  before_update :check_password_change
  attr_accessor :role_ids
  after_save :clear_cache
  def clear_cache
    Rails.cache.clear
  end

  def can? action
    Rails.cache.fetch("user_authorities_#{self.id}", expires_in: 300){
      self.authorities.active.map(&:action)
    }.include? action
  end

  DEPARTMENTS = {1 =>'商业呈现部', 2 => '珠宝设计部', 3 => '国内商业渠道部',4 => '产品技术部', 5 => '市场部', 6 => '财务部', 7 => '人力资源部',8 => '客服部',9 => '行政部', 10 => '商品管理部'}

  def check_role new_role_ids
    new_role_ids ||= []
    old_role_ids = self.editor_role_relationships.active.pluck(:role_id)
    add_role_ids = new_role_ids - old_role_ids
    del_role_ids = old_role_ids - new_role_ids
    ActiveRecord::Base.transaction do
      del_role_ids.each do |role_id|
        self.editor_role_relationships.active.where(role_id: role_id).first.destroy
      end
      add_role_ids.each do |role_id|
        self.editor_role_relationships.create(role_id: role_id)
      end
    end
  end


  def encrypt_password
    if password
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("")
      self.password = Digest::SHA1.hexdigest(self.password+self.salt)
    end
  end

  def check_password_change
    if self.password_change
      self.salt = (('a'..'z').to_a+(0..9).to_a+('A'..'Z').to_a).sample(32).join("") if self.salt.nil?
      self.password = Digest::SHA1.hexdigest(self.password+self.salt)
    end
  end

  def self.login name, password
    editor = Manage::Editor.find_by(email: name, active: true)
    if editor && Digest::SHA1.hexdigest(password+editor.salt) == editor.password
      return editor
    else
      return nil
    end
  end

end
