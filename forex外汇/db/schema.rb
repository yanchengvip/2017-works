# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180307071400) do

  create_table "account_traders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "跟投表" do |t|
    t.integer "trader_id", default: 0, comment: "交易员AccountID"
    t.integer "account_id", default: 0, comment: "跟随者AccountID"
    t.decimal "follow_amount", precision: 16, scale: 2, default: "0.0", comment: "跟随金额"
    t.integer "follow_type", default: 0, comment: "跟随类型 0:跟投交易员已建仓和新订单,1:仅跟投交易员开立的新订单"
    t.integer "status", default: 0, comment: "状态：0:正在跟投，1：取消跟投，2：暂停跟投"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dealer_id", default: 0, comment: "券商ID"
    t.integer "dealer_type", default: 1, comment: "券商类型：1:虚拟券商，2：约汇网券商"
  end

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "账户表" do |t|
    t.integer "user_id", default: 0, comment: "userID"
    t.string "name", comment: "真实姓名"
    t.string "email", comment: "邮箱"
    t.string "phone", comment: "手机号"
    t.integer "status", comment: "状态 1:启用,2：禁用"
    t.integer "typee", default: 0, comment: "用户类型 0普通用户，1交易员"
    t.integer "dealer_id", default: 0, comment: "券商ID"
    t.integer "dealer_type", default: 1, comment: "券商类型：1:虚拟券商，2：约汇网券商"
    t.integer "idnumber_type", default: 1, comment: "证件类型 1=身份证"
    t.string "idnumber", comment: "证件号码"
    t.string "address", comment: "住址"
    t.string "zipcode", comment: "邮编号"
    t.string "city", comment: "市"
    t.string "province", comment: "省"
    t.string "country", comment: "国家"
    t.string "mt4_account", comment: "MT4账号"
    t.string "mt4_group", comment: "MT4组"
    t.integer "leverage", default: 1, comment: "交易杠杆"
    t.decimal "balance", precision: 16, scale: 5, default: "0.0", comment: "余额"
    t.decimal "equity", precision: 16, scale: 5, default: "0.0", comment: "净值"
    t.decimal "margin", precision: 16, scale: 5, default: "0.0", comment: "已用保证金"
    t.decimal "margin_free", precision: 16, scale: 5, default: "0.0", comment: "可用保证金"
    t.text "comment", comment: "备注"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "管理员角色关系表" do |t|
    t.integer "admin_id", default: 0, comment: "管理员ID"
    t.integer "role_id", default: 0, comment: "角色ID"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "管理员表" do |t|
    t.string "nickname", comment: "登录名"
    t.string "phone", comment: "手机号"
    t.string "password", comment: "密码"
    t.string "salt", comment: "加密随机码"
    t.integer "status", default: 0, comment: "状态  0正常，1禁用"
    t.string "real_name", comment: "真实姓名"
    t.string "email", comment: "邮箱"
    t.string "login_ip", comment: "登录ip地址"
    t.datetime "login_time", comment: "最后一次登录时间"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authorities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "权限表" do |t|
    t.string "name", comment: "权限名称"
    t.string "action", comment: "具体权限 如user#create"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authority_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "权限角色关系表" do |t|
    t.integer "authority_id", comment: "权限ID"
    t.integer "role_id", comment: "角色ID"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dealers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "dealer_type"
    t.integer "status"
    t.text "desc"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mt4_trades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "真实交易" do |t|
    t.integer "account_id", default: 0, comment: "AccountID"
    t.string "mt4_account", comment: "下单用户的mt4账户"
    t.string "trader_mt4_account", comment: "被跟随交易员MT4账号"
    t.string "identifier", comment: "订单号"
    t.string "symbol", comment: "交易品种"
    t.integer "cmd", default: 0, comment: "0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop"
    t.integer "volume", default: 1, comment: "交易量1=0.01手"
    t.datetime "expiration", comment: "挂单过期时间"
    t.datetime "open_time", comment: "开仓时间"
    t.decimal "price", precision: 16, scale: 5, comment: "根据cmd类型表示价格，例如cmd=2,price为挂单买入价格"
    t.decimal "open_price", precision: 16, scale: 5, comment: "开仓价格"
    t.datetime "close_time", default: "1970-01-01 00:00:00", comment: "平仓时间;时间=\"1970-01-01 00:00:00\"为在仓单，反之则为平仓单"
    t.decimal "close_price", precision: 16, scale: 5, comment: "平仓价格"
    t.decimal "sl", precision: 16, scale: 5, comment: "止损价格"
    t.decimal "tp", precision: 16, scale: 5, comment: "止盈价格"
    t.decimal "commission", precision: 16, scale: 5, comment: "订单佣金"
    t.decimal "commission_agent", precision: 16, scale: 5, comment: "代理佣金"
    t.decimal "taxes", precision: 16, scale: 5, comment: "利息"
    t.decimal "profit", precision: 16, scale: 5, comment: "盈亏金额"
    t.decimal "margin", precision: 16, scale: 2, comment: "订单保证金"
    t.integer "dealer_id", default: 0, comment: "券商ID"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "角色表" do |t|
    t.string "name", comment: "角色名称"
    t.text "content", comment: "备注"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "用户表" do |t|
    t.string "nickname", comment: "昵称"
    t.string "phone", comment: "手机号"
    t.string "email", comment: "邮箱"
    t.string "password", comment: "密码"
    t.string "salt", comment: "加密随机码"
    t.integer "status", default: 1, comment: "状态;1:启用,2:禁用"
    t.string "head_img", comment: "头像地址"
    t.string "finger_login", comment: "指纹登录账号"
    t.string "finger_password", comment: "指纹登录密码"
    t.string "login_time", comment: "最后一次登录时间"
    t.string "login_device", comment: "登录设备"
    t.string "login_ip", comment: "登录ip地址"
    t.string "token", comment: "登录token"
    t.datetime "token_time", comment: "token过期时间"
    t.integer "sex", default: 0, comment: "性别 0 未知 1男 2女"
    t.datetime "birthday", comment: "生日"
    t.string "address", comment: "住址"
    t.boolean "is_agree", default: true, comment: "是否同意协议"
    t.text "desc", comment: "简介"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "virtual_trades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "虚拟交易表" do |t|
    t.integer "account_id", default: 0, comment: "AccountID"
    t.integer "trader_id", comment: "被跟随交易员ID"
    t.integer "trade_id", comment: "被跟随订单ID"
    t.string "identifier", comment: "订单号"
    t.string "symbol", comment: "交易品种"
    t.integer "cmd", default: 0, comment: "0 = BUY, 1 = SELL, 2 = BuyLimit, 3 = SellLimit, 4 = BuyStop, 5 = SellStop"
    t.integer "volume", default: 1, comment: "交易量1=0.01手"
    t.datetime "expiration", comment: "挂单过期时间"
    t.datetime "open_time", comment: "开仓时间"
    t.decimal "price", precision: 16, scale: 5, comment: "根据cmd类型表示价格，例如cmd=2,price为挂单买入价格"
    t.decimal "open_price", precision: 16, scale: 5, comment: "开仓价格"
    t.datetime "close_time", default: "1970-01-01 00:00:00", comment: "平仓时间;时间=\"1970-01-01 00:00:00\"为在仓单，反之则为平仓单"
    t.decimal "close_price", precision: 16, scale: 5, comment: "平仓价格"
    t.decimal "sl", precision: 16, scale: 5, comment: "止损价格"
    t.decimal "tp", precision: 16, scale: 5, comment: "止盈价格"
    t.decimal "commission", precision: 16, scale: 5, comment: "订单佣金"
    t.decimal "commission_agent", precision: 16, scale: 5, comment: "代理佣金"
    t.decimal "taxes", precision: 16, scale: 5, comment: "利息"
    t.decimal "profit", precision: 16, scale: 5, comment: "盈亏金额"
    t.decimal "margin", precision: 16, scale: 2, comment: "订单保证金"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wechat_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", comment: "微信用户" do |t|
    t.integer "user_id", comment: "用户ID"
    t.string "openid", comment: "微信的openid"
    t.string "nickname", comment: "微信昵称"
    t.integer "sex", default: 0, comment: "性别 0 未知 1男 2女"
    t.string "city", comment: "城市"
    t.string "province", comment: "省份"
    t.string "country", comment: "国家"
    t.string "head_img", comment: "头像地址"
    t.string "login_ip", comment: "登录ip地址"
    t.boolean "active", default: true, comment: "软删"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
