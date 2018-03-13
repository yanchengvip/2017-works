# module WisdomApi
#   module ClassMethods
#     # 开户
#     def external_account data
#       conn = Faraday.new
#       conn =  Faraday.new do |b|
#         b.request :multipart
#         # b.request :url_encoded
#         # b.adapter :net_http
#       end
#       conn = Faraday.new('http://test.wisfx.com/Home') do |f|
#         f.request :multipart
#         # f.request :url_encoded
#         f.adapter  Faraday.default_adapter # This is what ended up making it work
#       end

#       conn = Faraday.new(:url => "http://test.wisfx.com/Home") do |builder|
#         builder.request :multipart
#         builder.response :logger
#         builder.adapter Faraday.default_adapter
#       end

#       conn = Faraday.new(:url => "http://127.0.0.1:3000") do |conn|
#           # POST/PUT params encoders:
#           conn.request :multipart
#           conn.request :url_encoded
#           conn.response :logger
#           # Last middleware must be the adapter:
#           conn.adapter :net_http
#         end

#       response = conn.put '/Home/external_account' do |req|
#         req.body = data

#       end

#       conn = Faraday.new('http://127.0.0.1:3000') do |f|
#           f.request :multipart

#           f.adapter :net_http # This is what ended up making it work
#         end


#       response = conn.post '/external_account' do |req|
#         req.body = data

#       end

#       conn.post("/external_account", data)
#       conn.post("http://test.wisfx.com/external_account", data)
#     end

#     def test_external_account
#       { merchno: "WMB9X1AXA18K6LC",
#         name: "测试用户",
#         twid: "130281199000001212",
#         phonecode: "12345678901",
#         email: 'zhzyc142@163.com',
#         fileUpload1:  Faraday::UploadIO.new "/Users/yczhao/Downloads/858886-z.jpg", 'image/jpeg',
#         fileUpload2:  Faraday::UploadIO.new "/Users/yczhao/Downloads/858886-z.jpg", 'image/jpeg',
#         returnUrl: 'http://dww.ihaveu.com/wisdom',
#         signature: ''
#       }
#     end

#     def external_account_signature data
#       Digest::MD5.hexdigest( "day=#{Date.today.to_s.delete('-')}:name=#{data[:name]}:twid=#{data[:twid]}:phonecode=#{data[:phonecode]}:returnUrl=#{data[:returnUrl]}:merchno=#{data[:merchno]}:WQ@mc0S5!mXtL4uqwcS06LC").downcase
#     end

#     #入金
#     def external_deposit

#     end
#   end

#   module InstanceMethods

#   end

#   def self.included(receiver)
#     receiver.extend         ClassMethods
#     receiver.send :include, InstanceMethods
#   end
# end
