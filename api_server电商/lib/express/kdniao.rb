module Kdniao

    EBusinessID = "1305646"
    AppKey="379992b2-aa09-4716-94ec-8e955d4b3592"

    def self.query_express(shipper_code, logistic_code, order_code = "")
      sc = {
          'fedex'=>'FEDEX',
          'zjs'=>'ZJS',
          'ems'=>'EMS',
          'sf'=>'SF'
      }[shipper_code] || shipper_code
      url = "http://api.kdniao.cc/Ebusiness/EbusinessOrderHandle.aspx"
# OrderCode String  订单编号  O
# ShipperCode String  快递公司编码  R
# # LogisticCode  String  物流单号
      params ={OrderCode: order_code, ShipperCode: sc, LogisticCode: logistic_code }
      post(url, 1002, params)
    end

    def self.sign params
      string = params.to_json.gsub("\"", "\'")
      CGI.escape(Base64.encode64(Digest::MD5.hexdigest(string + AppKey)).delete("\n"))
    end

    def self.post(url,type, params)
# RequestData String  请求内容需进行URL(utf-8)编码。请求内容JSON格式，须和DataType一致。  R
# EBusinessID String  商户ID，请在我的服务页面查看。  R
# RequestType String  请求指令类型：1002 R
# DataSign  String  数据内容签名：把(请求内容(未编码)+AppKey)进行MD5加密，然后Base64编码，最后 进行URL(utf-8)编码。详细过程请查看Demo。 R
# DataType  String  请求、返回数据类型：2-json；
      body = {
        RequestData: CGI.escape(params.to_json.gsub("\"", "\'")),
        EBusinessID: EBusinessID,
        RequestType: type,
        DataSign: sign(params),
        # DataType: 2,
      }
      conn = Faraday.new
      conn.headers["Content-Type"]= "application/x-www-form-urlencoded";
      JSON.parse conn.post(url, body).body
    end
  end

