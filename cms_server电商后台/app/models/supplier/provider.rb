class Supplier::Provider < ApplicationRecord
  include DownloadCsv
  before_create :encrypt_password
  before_update :check_password_change

  validates :login, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  def invoice
    case invoice_type
    when 1
      0
    when 2
      0.03
    when 3
      0.11
    else
      0.17
    end
  end

  def self.auth login, password
    provider = Supplier::Provider.active.find_by(login: login)
    if provider && Digest::SHA1.hexdigest(password+provider.salt) == provider.password
      return provider
    else
      return nil
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

end
