module RsaSign
  module ClassMethods
    def rsa_private_sign(data, private_key)
      pri = OpenSSL::PKey::RSA.new(Base64.decode64 private_key)
      sign = pri.sign('sha1', data.force_encoding("utf-8"))
      signature = Base64.encode64(sign)
      signature = signature.delete("\n").delete("\r")
      return signature
    end
    #rsa 验签
    def sa_verify(data, sign, public_key)
      pub = OpenSSL::PKey::RSA.new(Base64.decode64(public_key))
      digester = OpenSSL::Digest::SHA1.new
      sign = Base64.decode64(sign)
      return pub.verify(digester, sign, data)
    end
  end

  module InstanceMethods

  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
