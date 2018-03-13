module AuctionTradeHelper
  extend ActiveSupport::Concern
  module ClassMethods


  end


  DELIVERY_SERVICES = [
      { :name => 'fedex', :title => '联邦快递', :url => 'https://www.fedex.com/fedextrack/?action=track&cntry_code=cn' },
      { :name => 'sf', :title => '顺丰速运', :url => 'http://sf-express.com/cn/sc/' },
      { :name => 'zjs', :title => '宅急送', :url => 'http://www.zjs.com.cn/WS_Business/WS_Business_GoodsTrack.aspx' },
      { :name => 'ems', :title => '邮政EMS', :search_name => 'ems', :url => 'http://www.ems.com.cn/mailtracking/you_jian_cha_xun.html' },
      { :name => 'offline', :title => '线下' },
      { :name => 'pickup', :title => '自取' },
      { :name => 'yt', :title => '圆通', :search_name => 'yuantong' },
      { :name => 'scic', :title => '中加国际快递' },
      { :name => 'bestex', :title => '百世汇通', :search_name => 'huitong' },
      { :name => 'zto', :title => '中通快递', :search_name => 'zhongtong' },
      { :name => 'deppon', :title => '德邦物流' },
      { :name => 'dhl', :title => 'DHL' },
      { :name => 'yunda', :title => '韵达', :search_name => 'yunda' },
      { :name => 'zyzoom', :title => '增速海淘' },
      { :name => 'ttkdex', :title => '天天快递', :search_name => 'tiantian' },
      { :name => 'xlobo', :title => '贝海国际快递' },
      { :name => 'express_au', :title => '鹰运国际速递' },
  ]

  BILL99_BANKS = [
      { :name => "abc", :title => "中国农业银行", },
      { :name => "bea", :title => "东亚银行", },
      { :name => "bob", :title => "北京银行", },
      { :name => "ccb", :title => "中国建设银行", },
      { :name => "ceb", :title => "中国光大银行", },
      { :name => "cib", :title => "兴业银行", },
      { :name => "cmb", :title => "招商银行", },
      { :name => "gdb", :title => "广东发展银行", },
      { :name => "hxb", :title => "华夏银行", },
      { :name => "sdb", :title => "深圳发展银行", },
      { :name => "bcom", :title => "中国交通银行", },
      { :name => "cbhb", :title => "渤海银行", },
      { :name => "cmbc", :title => "中国民生银行", },
      { :name => "icbc", :title => "中国工商银行", },
      { :name => "nbcb", :title => "宁波银行", },
      { :name => "njcb", :title => "南京银行", },
      { :name => "spdb", :title => "上海浦东发展银行", },
      { :name => "bjrcb", :title => "北京农村商业银行", },
      { :name => "citic", :title => "中信银行", },
      { :name => "post", :title => "中国邮政储蓄", },
      # { :name => "shrcc", :title => "上海农村商业银行", },
      { :name => "boc", :title => "中国银行", },
      # { :name => "gzrcc", :title => "广州市农村信用合作社", },
      { :name => "gzcb", :title => "广州市商业银行", },
      { :name => "hzb", :title => "杭州银行", },
      { :name => "pab", :title => "平安银行", },
      { :name => "hsb", :title => "徽商银行", },
      { :name => "shb", :title => "上海银行", },
      { :name => "czb", :title => "浙江银行", },
      { :name => "srcb", :title => "上海农村商业银行", },
      { :name => "psbc", :title => "中国邮政储蓄银行", },
      { :name => "upop", :title => "银联在线支付", },
  ]

  ALIPAY_BANKS = [
      { :name => "icbcbtb", :title => "中国工商银行（B2B）", },
      { :name => "abcbtb", :title => "中国农业银行（B2B）", },
      { :name => "ccbbtb", :title => "中国建设银行（B2B）", },
      { :name => "spdbb2b", :title => "上海浦东发展银行（B2B）", },
      { :name => "bocb2c", :title => "中国银行", },
      { :name => "icbcb2c", :title => "中国工商银行", },
      { :name => "cmb", :title => "招商银行", },
      { :name => "ccb", :title => "中国建设银行", },
      { :name => "abc", :title => "中国农业银行", },
      { :name => "spdb", :title => "上海浦东发展银行", },
      { :name => "cib", :title => "兴业银行", },
      { :name => "gdb", :title => "广东发展银行", },
      { :name => "sdb", :title => "深圳发展银行", },
      { :name => "cmbc", :title => "中国民生银行", },
      { :name => "comm", :title => "交通银行", },
      { :name => "citic", :title => "中信银行", },
      { :name => "hzcbb2c", :title => "杭州银行", },
      { :name => "cebbank", :title => "中国光大银行", },
      { :name => "shbank", :title => "上海银行", },
      { :name => "nbbank", :title => "宁波银行", },
      { :name => "spabank", :title => "平安银行", },
      { :name => "bjbank", :title => "北京银行", },
      { :name => "bjrcb", :title => "北京农村商业银行", },
      { :name => "fdb", :title => "富滇银行", },
      { :name => "comm", :title => "交通银行" },
      { :name => "cmb-debit", :title => "招商银行-借记卡", },
      { :name => "ccb-debit", :title => "中国建设银行-借记卡", },
      { :name => "icbc-debit", :title => "中国工商银行-借记卡", },
      { :name => "comm-debit", :title => "交通银行-借记卡", },
      { :name => "gdb-debit", :title => "广东发展银行-借记卡", },
      { :name => "boc-debit", :title => "中国银行-借记卡", },
      { :name => "ceb-debit", :title => "中国光大银行-借记卡", },
      { :name => "spdb-debit", :title => "上海浦东发展银行-借记卡", },
      { :name => "psbc-debit", :title => "中国邮政储蓄银行-借记卡", },
  ]

  YEEPAY_BANKS = [
      { name: 'ICBC-NET', title: '工商银行'},
      { name: 'ICBC-WAP', title: '工商银行WAP'},
      { name: 'CMBCHINA-NET', title: '招商银行WAP'},
      { name: 'CMBCHINA-WAP', title: '招商银行WAP'},
      { name: 'ABC-WAP', title: '中国农业银行'},
      { name: 'CCB-NET', title: '建设银行'},
      { name: 'CCB-PHONE', title: '建设银行WAP'},
      { name: 'BCCB-NET', title: '北京银行'},
      { name: 'BOCO-NET', title: '交通银行'},
      { name: 'CIB-NET', title: '兴业银行'},
      { name: 'NJCB-NET', title: '南京银行'},
      { name: 'CMBC-NET', title: '中国民生银行'},
      { name: 'CEB-NET', title: '光大银行'},
      { name: 'BOC-NET', title: '中国银行'},
      { name: 'PAB-NET', title: '平安银行'},
      { name: 'CBHB-NET', title: '渤海银行'},
      { name: 'HKBEA-NET', title: '东亚银行'},
      { name: 'NBCB-NET', title: '宁波银行'},
      { name: 'ECITIC-NET', title: '中信银行'},
      { name: 'SDB-NET', title: '深圳发展银行'},
      { name: 'GDB-NET', title: '广东发展银行'},
      { name: 'SPDB-NET', title: '上海浦东发展银行'},
      { name: 'POST-NET', title: '中国邮政'},
      { name: 'BJRCB-NET', title: '北京农村商业银行'}
  ]

  YEEPAY_CREDITCARD_BANK = [
      { name: 'JUNNET-NET', title: '骏网一卡通'},
      { name: 'SNDACARD-NET', title: '盛大卡'},
      { name: 'SZX-NET', title: '神州行'},
      { name: 'ZHENGTU-NET', title: '征途卡'},
      { name: 'QQCARD-NET', title: 'Q币卡'},
      { name: 'UNICOM-NET', title: '联通卡'},
      { name: 'JIUYOU-NET', title: '久游卡'},
      { name: 'YPCARD-NET', title: '易宝e卡通'},
      { name: 'NETEASE-NET', title: '网易卡'},
      { name: 'WANMEI-NET', title: '完美卡'},
      { name: 'SOHU-NET', title: '搜狐卡'},
      { name: 'TELECOM-NET', title: '电信卡'}
  ]

  YEEPAY_DIRECT_CONNECT_BANK = [
      { name: 'HXB-NET', title: '华夏银行'},
      { name: 'GNXS-NET', title: '广州市农村信用合作社'},
      { name: 'GZCB-NET', title: '广州市商业银行'},
      { name: 'SDE-NET', title: '顺德农信社'},
      { name: 'SHRCB-NET', title: '上海农村商业银行'}
  ]

  YEEPAY_PREPAID_CARD = [
      {name: 'Ybt-NET', title: '中欣银宝通卡'},
      {name: 'Aixin-NET', title: '爱心卡'},
      {name: 'AllScore-NET', title: '奥斯卡'},
      {name: 'Dazhong-NET', title: '大众e通卡'},
      {name: 'HUILIAN-NET', title: '国华汇联'},
      {name: 'GXJFT-NET', title: '集付宝'},
      {name: 'JXJiaofeitong-NET', title: '江西缴费通卡'},
      {name: 'JIANGSRX-NET', title: '瑞祥商联'},
      {name: 'Slsy-NET', title: '商联商用'},
      {name: 'Shangmeng-NET', title: '商盟统统付'},
      {name: 'WSTONGLIAN-NET', title: '万商通联'},
      {name: 'Yikahui-NET', title: '壹卡会'},
      {name: 'Edenred-NET', title: '雅高e卡'},
      {name: 'Bohaiyisheng-NET', title: '易生如意卡'},
      {name: 'Yitong-NET', title: '1039易通卡'},
      {name: 'Zhongfutong-NET', title: '城市通卡'}
  ]




  ALIPAY_CREDITCARD_BANKS = [
      { :name => "icbc", :title => "工商银行", },
      { :name => "abc", :title => "农业银行", },
      { :name => "cmb", :title => "招商银行", },
      { :name => "ccb", :title => "建设银行", },
      { :name => "boc", :title => "中国银行", },
      { :name => "sdb", :title => "深圳发展银行", },
      { :name => "ceb", :title => "光大银行", },
      { :name => "spabank", :title => "平安银行", },
  ]

  ALIPAY_INSTALLMENT_BANKS = [
      { :name => "boc-ccip", :title => "中国银行", },
      { :name => "boc-ccip-12", :title => "中国银行(12期)", },
      { :name => "spabank-ccip", :title => "平安银行", },
      { :name => "spabank-ccip-12", :title => "平安银行(12期)", },
      { :name => "abc-ccip", :title => "中国农业银行", },
      { :name => "abc-ccip-12", :title => "中国农业银行(12期)", },
  ]

  TENPAY_CREDITCARD_BANKS = [
      {name: 'icbc', title: '工商银行'},
      {name: 'ccb', title: '建设银行'},
      {name: 'abc', title: '农业银行'},
      {name: 'cmb', title: '招商银行'},
      {name: 'spdb', title: '上海浦发银行'},
      {name: 'sdb', title: '深圳发展银行'},
      {name: 'cib', title: '兴业银行'},
      {name: 'bob', title: '北京银行'},
      {name: 'ceb', title: '光大银行'},
      {name: 'cmbc', title: '民生银行'},
      {name: 'citic', title: '中信银行'},
      {name: 'gdb', title: '广东发展银行'},
      {name: 'pab', title: '平安银行'},
      {name: 'boc', title: '中国银行'},
      {name: 'comm', title: '交通银行'},
      {name: 'njcb', title: '南京银行'},
      {name: 'nbcb', title: '宁波银行'},
      {name: 'srcb', title: '上海农商'},
      {name: 'bea', title: '东亚银行'},
      {name: 'postgc', title: '邮储'},
      {name: 'ccbb2b', title: '建设银行(企业)'},
      {name: 'abcb2b', title: '农业银行(企业)'},
      {name: 'spdbb2b', title: '浦发银行(企业)'},
      {name: 'icbcb2b', title: '工商银行(企业)'},
      {name: 'cmbb2b', title: '招商银行(企业)'},
      {name: 'cebb2b', title: '光大银行'},
  ]

  INDEPENDENT_BANKS = [
      { :name => "alipay", :title => "支付宝", },
      { :name => "bill99", :title => "快钱", },
      { :name => "unionpay", :title => "中国银联", },
      { :name => "unionpay_wap", :title => "中国银联移动支付", },
      { :name => "lakala", :title => "拉卡拉", },
      { :name => "cmbchina", :title => "招商银行", },
      { :name => "ccb", :title => "中国建设银行", },
      { :name => "cmbc", :title => "中国民生银行", },
      { :name => "pab", :title => "平安银行", },
      { :name => "pgs", :title => "海航易支付", },
      { :name => "yeepay", :title => '易宝支付'},
      { :name => "boc_creditcard", :title => "中国银行快捷支付", },
      { :name => "boc", :title => "中国银行", },
      { :name => "comm_creditcard", :title => "交通银行快捷支付", },
      { :name => "cmbchina_creditcard", :title => "招商银行信用卡支付" },
      { :name => "cmbchina_yiwangtong", :title => "招商银行一网通" },
      { :name => "wechat", :title => "微信支付" },
      { :name => "wechat_app", :title => "微信APP支付" },
      { :name => "wechat_uxuan", :title => "微信支付(U选)" },
      { :name => "pab_pay", :title => "平安付" },
      { :name => "icbc", :title => "工商银行" },
      { :name => "tenpay", :title => "财付通" },
  ]

  PAYMENT = [
      { :name => "express", :title => "货到付款", },
      { :name => "giveaway", :title => "余额", },
      { :name => "paypal", :title => "paypal", },
      { :name => "shop", :title => "店铺", },
      { :name => "alipay_direct", :title => "支付宝_余额支付", },
      { :name => "alipay_moto", :title => "支付宝_快捷支付", },
      { :name => "alipay_installment", :title => "支付宝_分期支付", },
      { :name => "alipay_qr", :title => "支付宝_扫码支付", },
      { :name => "alipay_wallet", :title => "支付宝_移动_钱包支付"},
      { :name => "alipay_forex", :title => "支付宝分账"},
  ]

  PAYMENT_SERVICES = [
      {banks: PAYMENT+INDEPENDENT_BANKS},
      {banks: BILL99_BANKS, prefix: 'bill99_', name: '快钱_' },
      {banks: ALIPAY_BANKS, prefix: 'alipay_', name: '支付宝_网银支付_' },
      {banks: ALIPAY_CREDITCARD_BANKS, prefix: 'alipay_creditcard_', name: '支付宝_快捷支付_' },
      {banks: ALIPAY_INSTALLMENT_BANKS, prefix: 'alipay_installment_', name: '支付宝_分期支付_' },
      {banks: YEEPAY_PREPAID_CARD + YEEPAY_DIRECT_CONNECT_BANK + YEEPAY_CREDITCARD_BANK + YEEPAY_BANKS, prefix: 'yeepay_', name: '易宝_' },
      {banks: TENPAY_CREDITCARD_BANKS, prefix: 'tenpay_', name: '财付通_' },
  ].inject({}){|h, opt| h.update(opt[:banks].map{|b| { "#{opt[:prefix]||''}#{b[:name]}" => "#{opt[:name]||''}#{b[:title]}"}}.inject({}, &:merge)); h}

end