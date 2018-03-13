MyAlipay.app_id = ALIPAYCONFIG[:alipay][:app_id]  #APPID即创建应用后生成

MyAlipay.app_private_key = ALIPAYCONFIG[:alipay][:private_key]  #开发者应用私钥，由开发者自己生成

MyAlipay.alipay_public_key = ALIPAYCONFIG[:alipay][:alipay_public_key]  #支付宝公钥，由支付宝生成

MyAlipay.gateway_url = ALIPAYCONFIG[:alipay][:gateway_url]   #支付宝网关（固定）,根据个人情况可填写沙箱网关或者正式网关

MyAlipay.sign_type = 'RSA2'  #默认为RSA2  商户生成签名字符串所使用的签名算法类型，目前支持RSA2和RSA，推荐使用RSA2