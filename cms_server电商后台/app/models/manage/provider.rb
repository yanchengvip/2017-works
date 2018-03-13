class Manage::Provider < ApplicationRecord
  before_create :encrypt_password
  before_update :check_password_change
  self.table_name = 'supplier_providers'
  TYPE = {1 => '平台', 2 => '代销', 3 => '平台+代销', 4 => '自采'}
  INVOICETYPE = {1 => '普票', 2 => '3%增值税', 3 => '11%增值税', 4 => '17%增值税'} #如果增加类型 需在proiver.invoice 方法中增加对应的值
  ISDIRECTSHIP = {true => '是', false => '否'}
  ISCOD = {true => '是', false => '否'}

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
end
