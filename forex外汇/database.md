users(用户表)
    id              integer     ID
    nickname        string      昵称
    phone           string      手机号
    email           string      邮箱
    password        string      密码   
    salt            string      加密随机码
    status          integer     状态;1:启用,2:禁用
    head_img        string      头像地址
    finger_login    string      指纹登录账号
    finger_password string      指纹登录密码
    login_time      datetime    最后一次登录时间
    login_ip        string      登录ip地址
    login_device    string      登录设备
    token           string      登录token
    token_time      datetime    token过期时间
    sex             integer     性别 0 未知 1男 2女
    birthday        datetime    生日
    desc            text        简介
    address         string      住址
    is_agree        boolean     是否同意协议
    active          boolean     软删
    
accounts(账户表)
    user_id         integer     用户表UserID
    name            string      姓名
    email           string      邮箱
    phone           string      手机号
    typee           integer     用户类型 0普通用户，1交易员
    dealer_id       integer     券商表dealerID
    dealer_type     integer     券商类型：1:虚拟券商，2：约汇网券商
    status          integer     状态 1:启用,2：禁用    
    idnumber_type   string      证件类型  1:身份证
    idnumber        string      证件号
    address         string      地址
    zipcode         string      邮编
    city            string      城市
    province        string      省份
    country         string      国家
    mt4_account     string      MT4账号 
    mt4_group       string      MT4组
    leverage        integer     交易杠杆
    balance         decimal     余额
    equity          decimal     净值
    margin          decimal     已用保证金
    margin_free     decimal     可用保证金    
    comment         text        备注
    active          boolean     软删           
    
dealers(券商表)
    id              integer     ID
    name            string      券商名称
    dealer_type     integer     券商类型：1:虚拟券商，2：约汇网券商
    status          integer     状态1:启用,2：禁用
    desc            text        描述
    active          boolean     软删

account_traders(跟投表)
    id              integer     ID
    trader_id       integer     被跟随者交易员AccountID
    account_id      integer     跟随者AccountID
    follow_amount   decimal     跟随金额
    follow_type     integer     跟随类型 0:跟投交易员已建仓和新订单,1:仅跟投交易员开立的新订单
    status          integer     状态：0:正在跟投，1：取消跟投，2：暂停跟投
    dealer_id       integer     券商表dealerID
    dealer_type     integer     券商类型：1:虚拟券商，2：约汇网券商
    active          boolean     软删

        
virtual_trades(虚拟交易)
    id              integer     ID
    account_id      integer     账户ID
    trader_id       string      被跟随交易员ID
    trade_id        integer     被跟随订单ID
    identifier      string      订单号
    symbol          string      交易品种
    cmd             string      交易类型 0=BUY, 1=SELL, 2=BuyLimit,3=SellLimit,4=BuyStop,5=SellStop
    price           decimal     根据cmd类型表示价格，如果cmd=2,price为挂单买入价格
    expiration      datetime    挂单过期时间    
    volume          integer     交易手数
    open_time       datetime    开仓时间
    open_price      decimal     开仓价格
    close_time      datetime    平仓时间
    close_price     decimal     平仓价格
    sl              decimal     止损
    tp              decimal     止盈
    commission      decimal     订单佣金
    commission_agent decimal    代理佣金 
    taxes           decimal     利息    
    profit          decimal     盈亏金额
    margin          decimal     订单保证金  
    active          boolean     软删
    
mt4_trades(真实交易)
    id              integer     ID
    account_id      integer     账户ID
    mt4_account     string      MT4账号
    trader_mt4_account string   被跟随交易员MT4账号
    identifier      string      订单号
    symbol          string      交易品种
    cmd             string      交易类型 0=BUY, 1=SELL, 2=BuyLimit,3=SellLimit,4=BuyStop,5=SellStop
    price           decimal     根据cmd类型表示价格，如果cmd=2,price为挂单买入价格
    expiration      datetime    挂单过期时间 
    volume          integer     交易手数
    open_time       datetime    开仓时间
    open_price      decimal     开仓价格
    close_time      datetime    平仓时间
    close_price     decimal     平仓价格
    sl              decimal     止损
    tp              decimal     止盈
    commission      decimal     订单佣金
    commission_agent decimal    代理佣金 
    taxes           decimal     利息    
    profit          decimal     盈亏金额
    margin          decimal     订单保证金
    dealer_id       integer     券商表dealerID   
    active          boolean     软删
       
forex_products(外汇品种)
    id              integer     ID
    name            string      外汇名称
    symbol          string      外汇品种标志
    status          integer     状态：1：上架，2：下架
    trade_time      string      交易时间
    quoted_time     string      报价时间
    dot_price       string      点差
    min_num         string      小数位
    treaty_amount   string      合约数量    
    active          boolean     软删    
    
user_forex_products(用户关注的外汇品种)
    user_id         integer     用户ID
    forex_product_id integer    外汇品种ID
    active          boolean     软删 
    
financial_records(出入金记录表)
    id              integer     ID
    account_id      integer     账户ID
    amount          decimal     存/取金额
    balance         decimal     账户余额
    status          integer     交易状态 0-申请成功 1-申请失败 2-入/出 金完成
    typee           integer     类型 1：入金，2：出金
    active          boolean     软删
        
images(图片)
    id              integer     ID
    name            string      图片名称
    url             string      图片地址
    table_id        integer     所属表ID
    table_type      string      所属表名
    comment         string      备注
    active          boolean     软删
    
wechat_users(微信用户)
    id              integer     ID
    user_id         integer     用户ID
    openid          string      
    nickname        string      微信昵称
    sex             integer     性别 0 未知 1男 2女
    city            string      城市
    province        string      省份
    country         string      国家
    head_img        string      头像地址
    login_ip        string      登录ip地址
    active          boolean     软删    
    
    
    
    
admins(管理员)
    nickname        string      登录名
    phone           string      手机号
    password        string      密码
    salt            string      加密随机码
    status          integer     状态  0正常，1禁用
    real_name       string      真实姓名
    email           string      邮箱
    login_ip        string      登录ip地址
    login_time      datetime    最后一次登录时间
    active          boolean     软删     

roles(角色)
    id              integer     ID
    name            string      角色名称
    content         text        备注
    active          boolean     软删     
authorities(权限)
    id              integer     ID
    name            string      权限名称
    action          string      具体权限 如user#create
    active          boolean     软删
        
admin_roles(管理员角色关系表)
    id              integer     ID
    admin_id        integer     管理员ID
    role_id         integer     角色ID
    active          boolean     软删
    
authority_roles(权限角色关系表)
    id              integer     ID
    authority_id    integer     权限ID
    role_id         integer     角色ID
    active          boolean     软删