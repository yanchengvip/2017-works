class Api::Wisdom
  #1开户接口
  # @param [integer] user_id 用户id
  # @return ({data:{ url: ""}, status: 200, msg:"success"})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_account user_id
    params = {
      merchno: Setting['wisdom.merchno'],
      returnUrl: Setting.host + "/wisdom/external_account_callback?user_id=#{user_id}" ,
      signature: ''
    }
    params[:signature] = signature(params, [:returnUrl, :merchno])
    url = Setting['wisdom.host'] + "/Home/external_account?" + params.to_param
    {data:{ url: url}, status: 200, msg:"success"}
  end

  #2入金 / 3出金
  # @param [integer] account_id 用户id
  # @param [integer] login mt4账户
  # @param [integer] action 1 入金 2 出金
  # @return ({data:{ url: ""}, status: 200, msg:"success"})
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.financial_record login, account_id, action = 1
    params = {
      merchno: Setting['wisdom.merchno'],
      returnUrl: Setting.host + "/wisdom/financial_record_callback?account_id=#{account_id}&type=#{action}",
      login: login,
      signature: ''
    }
    params[:signature] = signature(params, [:login, :returnUrl, :merchno])
    if action == 1
      url = Setting['wisdom.host'] + "/Home/external_deposit?" + params.to_param
    else
      url = Setting['wisdom.host'] + "/Home/external_withdraw?" + params.to_param
    end
    {data:{ url: url}, status: 200, msg:"success"}
  end

  # #3 出金
  # # @param (see external_deposit)
  # # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  # def self.external_withdraw login, account_id
  #   params = {
  #     merchno: Setting['wisdom.merchno'],
  #     returnUrl: Setting.host + "/wisdom/financial_record_callback?account_id=#{account_id}",
  #     login: login,
  #     signature: ''
  #   }
  #   params[:signature] = signature(params, [:login, :returnUrl, :merchno])
  #   url = Setting['wisdom.host'] + "/Home/external_withdraw?" + params.to_param
  #   {data:{ url: url}, status: 200, msg:"success"}
  # end

  #4 设置服务器数据接口
  # @param [hash] params 服务器参数
  # @option [integer] type 0-新增 1-删除 2-更新
  # @option [string] svr_id 流水号 新增-系统自动生成 删除-必须传入原ID  更新-必须传入原ID
  # @option [string(32)] svr_name 服务器名称
  # @option [string(32)] ip ip
  # @option [string(32)] port port
  # @option [string(64)] desc 说明
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_mt4_config(params)
    params[:merchno] = Setting['wisdom.merchno']
    params[:signature] = signature(params, [:merchno, :type, :svr_name])
    api_post '/api/external_mt4_config', params
  end

  #5 取得服务器数据接口
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_get_mt4_config
    params = {merchno: Setting['wisdom.merchno']}
    params[:signature] = signature(params, [:merchno])
    api_post '/api/external_get_mt4_config', params
  end

  #6 设置客户MT4账户接口
  # @example {"merchno":"WMB9X1AXA18K6LC","twid":"123123123","signature":"9a93c81b6f398a5ed9f396659da8e867","datas":[{"svr_id":"1","login":"8000012591","pwd":"22","desc":"test_mt4_1"},{"svr_id":"2","login":"8000012591","pwd":"33","desc":"test_mt4)2"}]}
  # @param [string] twid 客户证件号码
  # @param [Array hash] datas MT4账户数据
  # @option datas [string(32)] svr_id MT4服务器ID
  # @option datas [string(32)] login Mt4账号
  # @option datas [string(32)] pwd Mt4交易密码
  # @option datas [string(64)] desc MT4账号描述
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_cust_mt4 twid, datas
    params = {merchno: Setting['wisdom.merchno'], twid: twid, datas: datas}
    params[:signature] = signature(params, [:merchno, :twid])
    api_post '/api/external_cust_mt4', params
  end

  #7 取得客户MT4账户接口
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_get_cust_mt4 twid
    params = {merchno: Setting['wisdom.merchno'], twid: twid}
    params[:signature] = signature(params, [:merchno, :twid])
    api_post '/api/external_get_cust_mt4', params
  end

  # 8 授权跟单接口
  # @param [hash] params 服务器参数
  # @option params[string(32)] twid 证件号码
  # @option params[string(32)] master_login 主账号
  # @option params[string(32)] slave_login 子账号
  # @option params[string(32)] type 跟单模式
  # @option params[string(32)] value
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_mt4_authorize params
    params[:merchno] =  Setting['wisdom.merchno']
    params[:signature] = signature(params, [:merchno, :twid, :master_login, :slave_login])
    api_post '/api/external_get_cust_mt4', params
  end

  # 9 取消授权跟单接口
  # @param [hash] params 服务器参数
  # @option params[string(32)] twid 证件号码
  # @option params[string(32)] master_login 主账号
  # @option params[string(32)] slave_login 子账号
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.external_mt4_authorize params
    params[:merchno] =  Setting['wisdom.merchno']
    params[:signature] = signature(params, [:merchno, :twid, :master_login, :slave_login])
    api_post '/api/external_mt4_cancel_authorize', params
  end

  #签名
  # @param [Hash] params  待签名数据
  # @param [Array] keys  签名字段顺序
  # @return (string signature)
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.signature params, keys = []
    params = params.as_json.with_indifferent_access
    str = "day=#{Date.today.to_s.delete('-')}"
    keys.each do |key|
      str += ":#{key.to_s}=#{params[key]}"
    end
    str += ":#{Setting['wisdom.secret']}"
    Digest::MD5.hexdigest(str).downcase
  end

  #api post 返回json
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.api_post action, params
    conn = Faraday.new
    conn.post(Setting['wisdom.api_host'] + action, params).body
  end

  #发送post 请求
  # @param action [string] 网关地址
  # @author yacheng.zhao <yacheng.zhao@ihaveu.net>
  def self.post action, params
    conn = Faraday.new(:url => Setting['wisdom.host']) do |b|
      b.request :multipart
      b.request :url_encoded
      b.response :logger
      b.adapter :net_http
    end
    conn.post(action, params)
  end


end
