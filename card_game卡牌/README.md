## feature/v1.0.1

### 修改宝箱 去掉青铜 黄金宝箱为免费次数开启

### 增加抢兑模块

### 增加提现模块

### 增加红包雨模块



redis
  priod:id:codes期次号码
  period:id:user:id用户号码
  period:id:user:id:card:id用户技能牌
  period:id:left_codes剩余号码
  invite_times:user:id邀请次数
  invite_left_amount_day:day每日邀请好友剩余金额



期次:mammon_periods  志新
  invite_amount_day每日邀请好友分享金额上限
  邀请者邀请好友奖励金额
  被邀请好友注册获得奖励金额
  被邀请者号码及技能牌领取有效期
  首次登陆送2张卡牌
  num:期次
  pre_begin_time: 准开始时间， 改时间内邀请用户赠送的号码 放到该 期次中
  begin_time:开始时间
  end_time：结束时间
  amount：奖品总金额
  code：幸运号码
  code_count：号码总数，每日全局?每日上限10000个，从0000至9999，给用户发放号码不会重复
  red_package_rule_id：红包规则id
  invite_amount：邀请分享金额上限（全局配置每日？）
  rest_time 休整时间，全局？
  red_package_time 竞赛结束后触发红包雨时间，全局？
  is_win:幸运大奖是否开启
  left_code_count:
  left_amount:
  status发放完毕

期次奖励:mammon_period_items 志新
  prize_num: 奖品等级 0,1,2,3
  amount：等级基础金额
  yesterday_balance:昨日结转
  today_balance:今日结算

中奖明细:mammon_user_winnings 闫成
    mammon_period_item_id
    user_id
    period_id：期次
    code：中奖号码
    amount：中奖金额
    prize_num: 中奖等级0,1,2,3 统计
    status:是否领取

用户号码记录表:mammon_user_codes 闫成
  user_id
  period_id
  codes
  count #号码变化数量
  status
  attack_user_id #攻击者用户ID
  type 1 被攻击减少  2 攻击别人获得 3首次登陆赠送 4 邀请赠送

技能牌:mammon_cards（共100张） 王霞
  name：名称
  num:编号？
  card_type:类型
  percent:抽取概率
  effect_percent：获取百分比
  effect_times：生效次数

邀请记录:mammon_invite_record  一个邀请记录会有多个数据 a 邀请b 送 现金 1条  送号码 一条 送卡牌 一条 每个卡牌算一个类型 王霞
  user_id
  invite_user_id
  period_id
  prize_type:奖励类型 8中 100 是现金 200 是号码 （0-100）式卡牌编号
  prize_count:奖励数量
  status:是否发放（领取）

攻击记录:mammon_attack_record 亚成
  from_user_id
  to_user_id
  period_id
  codes获得号码
  card_id

用户技能牌:mammon_user_cards 王霞
  user_id
  card_id
  period_id
  count
  status:是否有效



接口设计：

1、 用户邀请并被邀请者成功注册后发放 邀请奖励接口 （java调用） 王霞

根据当前奖励余额 给 邀请者 被邀请者 发放奖励

2、 财神首页 当期财神数据接口  首次签到赠送技能牌？ 还是直接登录首页就弹框（合并到接口2）  志新 (原型主页面 + 每日技能牌)

3、 号码明细接口 闫成 (原型我的号码)

4、 号码记录接口（攻击 被攻击 邀请获得明细） 亚成 （原型号码记录）

5、 复仇接口 亚成（原型号码记录）

6、 邀请成功页面 王霞（原型邀请成功）

7、 财神福利接口 志新（原型财神福利）

8、 分享页面 + 邀请好友 获取奖励信息接口 王霞（原型 分享页面 + 邀请好友）

9、  使用技能牌接口 亚成

10、 开奖接口 闫成 并计算每个人该获得 奖金明细 充值到AccountTicketBalanceDetail 表中

11、用户持有技能牌及数量借口 赵亚成

12、用户卡牌增效状态接口 赵亚成

13、 中将结果查看接口 闫成

svn地址：
http://10.3.201.8/svn/project/product_doc/%E9%87%8D%E5%AE%9D%E5%A5%87%E5%85%B5/20180206%E6%96%B0%E6%98%A5%E6%8E%A8%E5%B9%BF%E6%B4%BB%E5%8A%A8

http://10.3.201.8/svn/project/product_doc
