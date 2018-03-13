module Menus
  module SideMenus
    def self.list
      m1 = lottery_shop_menus #战场管理
      m2 = card_shop_menus #卡牌商城
      m3 = system_manage #系统管理
      m4 = mall_products #奇珍商城
      m5 = market_manage #营销管理
      m6 = statement_manage #报表管理
      m7 = products #商品管理
      m8 = statis
      m9 = copy_manage
      m10 = box_manage
      m11 = red_package_menus #红包管理
      m12 = mammon_menus #财神
      all_side_menus = {}
      all_side_menus = all_side_menus.merge(m1).merge(m2).merge(m3).merge(m4).merge(m5).merge(m6).merge(m7).merge(m8).merge(m9).merge(m10).merge(m11).merge(m12)
    end

    #红包
    def self.red_package_menus
      side_menus = {
        menu11: [
          {
              grandfather: '红包管理',
              parent: '红包',
              children: [
                  {
                      name: '红包列表',
                      url: "/promotion/red_packages"
                  },
                  {
                      name: '用户红包明细',
                      url: '/promotion/red_package_items'
                  },
                  {
                      name: '红包规则',
                      url: '/promotion/red_package_rules'
                  },
              ]
          },
          {
              grandfather: '回收管理',
              parent: '回收',
              children: [
                  {
                      name: '回收规则列表',
                      url: "/recoveries"
                  },
                  {
                      name: '回收明细列表',
                      url: "/recovery_items"
                  },
                  {
                      name: '每月提现记录',
                      url: "/pay/withdrawals_orders"
                  },
                  {
                    name: '提现记录',
                    url: "/pay/withdrawals_orders/withdraw_cash"
                  }
              ]
          }
        ]
      }
    end


    #夺宝商城菜单列表
    def self.lottery_shop_menus
      side_menus = {
          menu1: [
              {
                  grandfather: '赛场管理',
                  parent: '商品',
                  children: [
                      # {
                      #     name: '商品分类',
                      #     url: "/product_tags"
                      # },
                      {
                          name: '平台赛场商品',
                          url: '/game_types/game_products'
                      },
                      {
                          name: '自建赛场商品',
                          url: '/game_types/self_game_products'
                      },


                  ]

              },
              {
                  grandfather: '赛场管理',
                  parent: '赛场类型管理',
                  children: [
                      {
                          name: '赛场类型列表',
                          url: '/game_types'

                      },
                      {
                          name: '新增赛场类型',
                          url: '/game_types/new'

                      },
                      {
                          name: '赛场列表',
                          url: '/games'
                      }
                  ]
              },
              {
                  grandfather: '赛场管理',
                  parent: '赛场规则管理',
                  children: [
                      {
                          name: '赛场规则列表',
                          url: '/game_rules'
                      },
                      {
                          name: '自建赛场规则列表',
                          url: '/self_game_rules'
                      },
                      {
                          name: '卡包管理',
                          url: '/card_bags'
                      }
                  ]
              },
              {
                  grandfather: '夺宝商城',
                  parent: '获胜信息',
                  children: [
                    {
                      name: '竞赛胜利记录',
                      url: '/battle_winning_records'
                    },
                  # {
                  #     name: '失败订单列表',
                  #     url: '/battle_winning_records?order_type=1'

                  # }
                  ]
              },
              {
                grandfather: '夺宝商城',
                parent: '联赛',
                children: [
                  {
                    name: '联赛列表',
                    url: '/game_leagues'
                  },
                  {
                    name: '复活',
                    url: '/game_leagues/relive_rule'
                  },
                  {
                    name: '联赛规则',
                    url: '/game_leagues/league_rule'
                  },
                ]
              }
          ]
      }
    end


    #卡牌商城菜单列表
    def self.card_shop_menus
      side_menus = {
          menu2: [
              {
                  grandfather: '能量商城',
                  parent: '能量商城',
                  children: [
                      {
                          name: '能量商品列表',
                          url: '/energy_products'

                      },
                      {
                          name: '添加能量商品',
                          url: '/energy_products/new'

                      }
                  ]
              },
              {
                  grandfather: '能量商城',
                  parent: '礼包分类管理',
                  children: [
                      {
                          name: '添加礼包分类',
                          url: '/package_types/new'

                      },
                      {
                          name: '礼包分类列表',
                          url: '/package_types'

                      }
                  ]
              },
              {
                  grandfather: '能量商城',
                  parent: '礼包管理',
                  children: [
                      {
                          name: '添加礼包',
                          url: '/packages/new'

                      },
                      {
                          name: '礼包列表',
                          url: '/packages'

                      },
                      {
                          name: '礼包购买记录',
                          url: '/packages/buy_record'

                      }
                  ]

              }

          ]
      }
    end

    # 系统管理菜单列表
    def self.system_manage
      side_menus = {
          menu3: [
              {
                  grandfather: '系统管理',
                  parent: '帐号权限管理',
                  children: [
                      {
                          name: '个人信息',
                          url: "/profile"
                      },
                      {
                          name: '管理员列表',
                          url: '/admins'
                      },
                      {
                          name: '角色列表',
                          url: '/roles'
                      },
                      {
                          name: '资源管理',
                          url: '/authority_resources'
                      }

                  ]
              },
              {
                  grandfather: '系统管理',
                  parent: '卡牌管理',
                  children: [
                      # {
                      #   name: '添加卡牌',
                      #   url: '/cards/new'
                      # },
                      {
                          name: '卡牌列表',
                          url: '/cards'
                      },
                      # {
                      #     name: '卡牌规则',
                      #     url: '/card_rules'

                      # }
                  ]
              },
              # {
              #     grandfather: '系统管理',
              #     parent: '饕餮管理',
              #     children: [
              #         # {
              #         #     name: '粮草设置',
              #         #     url: '/forage_settings/set_forage'
              #         # },
              #         {
              #             name: '饕餮设置',
              #             url: '/glutton_settings/set_glutton'
              #         },
              #     ]
              # },
              {
                  grandfather: '系统管理',
                  parent: '饕餮设置',
                  children: [
                      {
                          name: '等级设置',
                          url: '/glutton_levels'
                      },
                      {
                          name: '技能设定',
                          url: '/glutton_skills'
                      },
                      {
                          name: '头像框管理',
                          url: '/head_frames'
                      },
                      {
                          name: '饕餮规则',
                          url: '/web_settings/glutton_rule'
                      },
                  ]
              },
              {
                  grandfather: '系统管理',
                  parent: '道具设置',
                  children: [
                      {
                          name: '参赛券',
                          url: '/game_props/vouchers'
                      },
                      {
                          name: '锦囊',
                          url: '/game_props/silk_bags'
                      },
                      {
                          name: '妖丹设置',
                          url: '/game_props/demons'
                      },
                  ]
              },
              {
                  grandfather: '系统管理',
                  parent: '版本管理',
                  children: [
                      {
                          name: '版本列表',
                          url: '/app_versions'
                      },
                  ]
              },
              {
                  grandfather: '系统管理',
                  parent: '其它管理',
                  children: [
                      {
                          name: '赛点管理',
                          url: '/web_settings/match_point'
                      },
                      {
                          name: '赛场信息提示',
                          url: '/web_settings/game_tip'
                      },
                      {
                          name: '战役&卡牌配置',
                          url: '/web_settings/card_give'
                      },
                      # {
                      #     name: '赠品管理',
                      #     url: '/gifts'
                      # },
                      # {
                      #     name: '文案管理',
                      #     url: '/copies'
                      # },
                      {
                          name: '头像管理',
                          url: '/headimgs'
                      },
                      {

                          name: '操作日志',
                          url: '/admins/audited_type'
                      },
                      {

                          name: '渠道管理',
                          url: '/qrcodes'
                      },


                  ]
              }
          ]
      }
    end


    #奇珍商城菜单列表
    def self.mall_products
      side_menus = {
          menu4: [
              {
                  grandfather: '兑奖阁管理',
                  parent: '兑奖阁管理',
                  children: [
                      {
                          name: '商品列表',
                          url: "/mall_products"
                      },
                      # {
                      #     name: '在售商品',
                      #     url: "/mall_products/onshelf"
                      # },
                      {
                          name: '兑换记录',
                          url: "/mall_orders"
                      },
                  ]
              }
          ]
      }
    end

    # 营销管理菜单列表
    def self.market_manage
      side_menus = {
          menu5: [
              {
                  grandfather: '营销管理',
                  parent: '消息通知',
                  children: [
                      {
                          name: '推送消息',
                          url: '/msg_records'
                      },
                      {
                          name: '公告管理',
                          url: '/msg_records/notices'
                      },
                      {
                          name: '活动消息',
                          url: '/msg_records/activities'
                      }
                  ]
              },
              {
                  grandfather: '营销管理',
                  parent: '能量管理',
                  children: [
                      # {
                      #   name: '用户卡牌',
                      #   url: '/card_user_owns'
                      # },
                      {
                          name: '赠送能量',
                          url: '/card_user_owns/user_energy'
                      },
                  ]
              },
              {
                  grandfather: '营销管理',
                  parent: '任务配置',
                  children: [
                      {
                          name: '任务列表',
                          url: '/task_settings'
                      },
                      {
                          name: '添加任务',
                          url: '/task_settings/new'
                      },
                  ]
              },
              {
                  grandfather: '营销管理',
                  parent: '幸运儿管理',
                  children: [
                      {
                          name: '幸运儿列表',
                          url: '/game_luckies'
                      },
                  ]
              },
              {
                  grandfather: '营销管理',
                  parent: '用户',
                  children: [
                      # {
                      #     name: '免费宝箱',
                      #     url: '/activities/new'
                      # },
                      # {
                      #     name: '添加至尊宝箱',
                      #     url: '/extreme_chests/new'
                      # },
                      # {
                      #     name: '至尊宝箱列表',
                      #     url: '/extreme_chests'
                      # },
                      {
                        name: '注册激活',
                        url: '/users/user_login_first'
                      }
                  ]

              },
          ]
      }
    end

    #报表管理菜单列表
    def self.statement_manage
      side_menus = {
          menu6: [
              {
                  grandfather: '报表',
                  parent: '报表管理',
                  children: [
                      {
                          name: '用户列表',
                          url: '/users'
                      },
                      {
                          name: '用户卡牌列表',
                          url: '/card_user_records'
                      },
                      {
                          name: '用户充值微积分',
                          url: '/account_logs'
                      }
                  ]
              },
              grandfather: '战役',
              parent: '战役',
              children: [
                  {
                      name: '战役',
                      url: '/battles/csv_index'
                  },
                  {
                      name: '中奖列表',
                      url: '/battle_winning_records/csv_index'
                  },
                  {
                      name: '兑换列表',
                      url: '/mall_orders/csv_index'
                  }
              ]
          ]
      }
    end

    #商品管理菜单列表
    def self.products
      side_menus = {
          menu7: [
              {
                  grandfather: '商品管理',
                  parent: '商品管理',
                  children: [
                      {
                          name: '商品列表',
                          url: "/battle_products"
                      },
                      {
                          name: '添加商品',
                          url: "/battle_products/new"
                      },
                      {
                          name: '赛场商品分类',
                          url: "/game_product_tags"
                      },
                      {
                          name: '自建赛场商品分类',
                          url: "/product_tags"
                      },
                      {
                          name: '兑奖阁商品分类',
                          url: "/mall_product_tags"
                      },
                      {
                          name: '库存管理',
                          url: "/battle_products/inventory_count_manage"
                      },
                      # {
                      #     name: '订单管理',
                      #     url: "/battle_products/orders"
                      # }
                  ]
              },
              {
                grandfather: '商品管理',
                parent: '订单管理',
                children: [
                  {
                    name: '商品订单管理',
                    url: "/battle_products/orders"
                  },
                  {
                    name: '充值订单审核',
                    url: "/recharges"
                  },
                  {
                    name: '未通过订单',
                    url: "/recharges/cancels"
                  },
                  {
                    name: '手机充值订单详情',
                    url: "/recharges/phone"
                  },
                  {
                    name: '赛场入场券订单',
                    url: "/recharges/ticket"
                  },
                  {
                    name: '赛场兑奖券订单',
                    url: "/recharges/coupons"
                  },
                  {
                    name: '赛场宝箱符订单',
                    url: "/recharges/bxf"
                  },
                ]
              }
          ]
      }
    end

    def self.statis
      side_menus = {
          menu8: [
              {
                  grandfather: '数据统计',
                  parent: '数据统计',
                  children: [
                      {
                          name: '基本信息',
                          url: "/statis"
                      },
                      {
                          name: '余额明细',
                          url: "/statis/balance"
                      },
                      {
                          name: '能量明细',
                          url: "/statis/energy"
                      },
                      {
                          name: '功勋明细',
                          url: "/statis/glory"
                      },
                      {
                          name: '微集分明细',
                          url: "/statis/score"
                      },
                      {
                          name: '渠道数据',
                          url: "/statis/channel"
                      },
                      {
                          name: '活跃数据',
                          url: "/statis/activy"
                      },
                      {
                          name: '赛场数据',
                          url: "/statis/game"
                      },
                      {
                          name: '充值数据',
                          url: "/statis/recharge"
                      },
                      {
                          name: '兑换数据',
                          url: "/statis/exchange"
                      },
                      {
                          name: '首页访问数量',
                          url: "/statis/request_source"
                      },
                      {
                          name: '首页访问数量(按天)',
                          url: "/statis/request_source_day"
                      },
                      {
                          name: '下载',
                          url: "/statis/download_source"
                      },
                      {
                          name: '下载(按天)',
                          url: "/statis/download_source_day"
                      },
                      {
                          name: 'h5推广宝箱PV统计',
                          url: "/statis/pv_count"
                      },
                      {
                          name: 'APP开屏宝箱PV统计',
                          url: "/statis/app_box_count"
                      },
                      {
                          name: '财神数据统计',
                          url: "/statis/mammon"
                      },
                      {
                          name: '邀请人数统计',
                          url: "/statis/invite_count"
                      },
                      {
                        name: '卡牌使用记录',
                        url: "/statis/attack_record"
                      },
                      {
                        name: '红包领取记录',
                        url: "/statis/package_record"
                      }
                  ]
              }
          ]
      }
    end

    def self.copy_manage
      side_menus = {
          menu9: [
              {
                  grandfather: '文案管理',
                  parent: '赛场文案',
                  children: [
                      {
                          name: '赛场文案',
                          url: '/msg_chats'
                      },
                  ]
              },
              {
                  grandfather: '文案管理',
                  parent: '邮件管理',
                  children: [
                      {
                          name: '邮件类型',
                          url: '/mail_types'
                      },
                      {
                          name: '邮件文案',
                          url: '/mails'
                      },

                  ]
              },
              {
                  grandfather: '文案管理',
                  parent: '其他文案',
                  children: [
                      {
                          name: '文案管理',
                          url: '/copies'
                      },
                  ]
              },
          ]
      }
    end

    def self.box_manage
      side_menus = {
          menu10: [
            {
              grandfather: '宝箱',
              parent: '宝箱管理',
              children: [
                # {
                #   name: '旧宝箱设置',
                #   url: '/treasure_boxs'
                # },
                {
                  name: '宝箱奖品',
                  url: '/chest_prizes'
                },
                {
                  name: '宝箱列表',
                  url: '/chest_boxs'
                },
                {
                  name: '宝符明细',
                  url: '/account_ticket_details/treasure_amount'
                },
                {
                  name: '开启记录',
                  url: '/chest_records'
                },
                {
                    name: '推广页设定',
                    url: '/box_lucky_walls'
                },
                {
                    name: '兑换码',
                    url: '/box_prize_codes'
                },

                {
                  name: '配置',
                  url: '/settings'
                },
                {
                  name: '顶部广播',
                  url: '/chest_broadcasts'
                },
                {
                    name: '签到管理',
                    url: '/sign_gift_settings'
                },
                {
                    name: '宝箱抽奖文案',
                    url: '/chest_box_msgs'
                },
                {
                    name: '账户宝箱符余额',
                    url: '/account_ticket'
                },
                {
                    name: '开启机会明细',
                    url: '/account_ticket_details/open_ticket_list'
                },
                {
                    name: '现金宝箱推荐配置',
                    url: '/chest_boxs/cash_box'
                },
              ]
            },
            {
              grandfather: '宝箱管理',
              parent: '充值管理',
              children: [
                {
                  name: '充值订单审核',
                  url: '/chest_orders'
                },
                {
                  name: '未通过订单',
                  url: '/chest_orders/cancels'
                },
                # {
                #   name: '手机充值记录',
                #   url: '/chest_orders/phone_static'
                # },
                {
                  name: '手机充值订单详情',
                  url: '/chest_orders/phone'
                },
                {
                  name: '京东卡',
                  url: '/jd_cards'
                },

              ]
            },
          ]
      }
    end

    #财神
    def self.mammon_menus
      side_menus = {
        menu12: [
          {
              grandfather: '财神',
              parent: '期次管理',
              children: [
                  {
                      name: '期次列表',
                      url: "/mammon/periods"
                  },
                  {
                      name: '中奖记录',
                      url: "/mammon/user_winnings/period_list"
                  },
                  {
                    name: '技能牌',
                    url: "/mammon/cards"
                  },
                  {
                    name: '开奖规则',
                    url: "/mammon/periods/rule"
                  },
                  {
                    name: '解锁',
                    url: "/mammon/periods/unlock"
                  }

              ]
          },
        ]
      }
    end

  end
end
