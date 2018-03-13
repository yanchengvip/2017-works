module Menus
  module SideMenus
    def self.list
      m1 = content_menus #内容管理
      m2 = products_menus #商品管理
      m3 = orders_menus #订单管理
      m4 = operate_menus #运营管理
      m5 = providers_menus #供应商管理
      m6 = permission_menus #权限管理
      # m7 = supplier_products_menus #供应商商品菜单
      all_side_menus = {}
      all_side_menus = all_side_menus.merge(m1).merge(m2).merge(m3).merge(m4).merge(m5).merge(m6)
    end


    #内容管理
    def self.content_menus
      side_menus = {
          menu1: [
              {
                  grandfather: '内容管理',
                  parent: '轮播管理',
                  children: [
                      {
                          name: '轮播列表',
                          url: '/auction/pic_ads',
                          action: "auction/pic_ads#index"
                      },
                      {
                          name: '新建轮播',
                          url: '/auction/pic_ads/new',
                          action: "auction/pic_ads#new"
                      },
                  ]

              },
              {
                  grandfather: '内容管理',
                  parent: '专题管理',
                  children: [
                      {
                          name: '专题列表',
                          url: '/auction/themes',
                          action: "auction/themes#index"
                      },
                      {
                          name: '新建商品专题',
                          url: '/auction/themes/new',
                          action: "auction/themes#new"
                      },
                  ]

              },
              {
                  grandfather: '内容管理',
                  parent: 'H5管理',
                  children: [
                      {
                          name: 'H5列表',
                          url: '/auction/mails',
                          action: "auction/mails#index"
                      },
                      {
                          name: '新建H5',
                          url: '/auction/mails/new',
                          action: "auction/mails#new"
                      },
                  ]

              },

          ]
      }
    end

    # 商品管理
    def self.products_menus
      side_menus = {
          menu2: [
            {
              grandfather: '商品管理',
              parent: '商品管理',
                children: [
                  {
                      name: '商品列表',
                      url: '/auction/products',
                      action: "auction/products#index"
                  },
                  {
                      name: '买手审核',
                      url: '/auction/products/ms_review_index',
                      action: "auction/products#ms_review_index"
                  },
                  {
                      name: '总监审核',
                      url: '/auction/products/zj_review_index',
                      action: "auction/products#zj_review_index"
                  },
                  {
                      name: '财务审核',
                      url: '/auction/products/cw_review_index',
                      action: "auction/products#cw_review_index"
                  },
                  {
                      name: '编辑审核',
                      url: '/auction/products/editor_review_index',
                      action: "auction/products#editor_review_index"
                  },
                  {
                      name: '审核记录',
                      url: '/auction/products/review_log',
                      action: "auction/products#review_log"
                  },
                ]
            },
            {
              grandfather: '商品管理',
              parent: '品牌管理',
                children: [
                  {
                      name: '品牌列表',
                      url: '/auction/brands',
                      action: "auction/brands#index"

                  },
                  {
                      name: '新增品牌',
                      url: '/auction/brands/new',
                      action: "auction/brands#new"

                  },
                ]
            },
            {
              grandfather: '商品管理',
              parent: '类目管理',
              children: [
                {
                    name: '类目列表',
                    url: '/auction/categories',
                    action: "auction/categories#index"
                },
                {
                    name: '新增类目',
                    url: '/auction/categories/new',
                    action: "auction/categories#new"
                },
              ]
            },
            {
              grandfather: '商品管理',
              parent: '属性管理',
                children: [
                  {
                      name: '属性列表',
                      url: '/auction/attributes',
                      action: "auction/attributes#index"

                  },
                  {
                      name: '新增属性',
                      url: '/auction/attributes/new',
                      action: "auction/attributes#new"

                  },
                ]
            }

          ]
      }
    end

    # 订单管理
    def self.orders_menus
      side_menus = {
          menu3: [
              {
                  grandfather: '订单管理',
                  parent: '订单管理',
                  children: [
                      {
                          name: '订单列表',
                          url: '/auction/trades',
                          action: "auction/trades#index"
                      },
                      # {
                      #     name: '商家订单列表',
                      #     url: '/auction/supplier_trades',
                      #     action: "auction/supplier_trades#index"
                      #
                      # },
                      {
                          name: '退款管理',
                          url: '/auction/trade_refunds',
                          action: "auction/trade_refunds#index"
                      },
                      {
                          name: '退货管理',
                          url: '/auction/supplier_trades/returns',
                          action: "auction/supplier_trades#returns"
                      },
                      # {
                      #     name: '拒签管理',
                      #     url: '/auction/supplier_trades/rejects',
                      #     action: "auction/supplier_trades#rejects"
                      # },
                      {
                        name: '财务收款',
                        url: '/auction/cashiers',
                        action: "auction/cashiers#index"
                      }

                  ]
              },
              {
                grandfather: '优惠券订单',
                parent: '优惠券订单',
                children: [
                  {
                    name: '优惠券订单',
                    url: '/auction/voucher_trades',
                    action: "auction/voucher_trades#index"
                  }
                ]

              }
          ]
      }
    end

    # 运营管理
    def self.operate_menus
      side_menus = {
          menu4: [
            {
              grandfather: '运营管理',
              parent: '秒杀管理',
              children: [
                {
                    name: '秒杀列表',
                    url: '/auction/seckills',
                    action: "auction/seckills#index"
                },
                {
                    name: '新建秒杀',
                    url: '/auction/seckills/new',
                    action: "auction/seckills#new"

                },
              ]

            },
            {
              grandfather: '运营管理',
              parent: '券种管理',
              children: [
                {
                    name: '券种列表',
                    url: '/auction/events',
                    action: "auction/events#index"
                },
                {
                  name: '添加券种',
                  url: '/auction/events/new',
                  action: "auction/events#new"
                },
              ]

            },
            {
              grandfather: '运营管理',
              parent: '发放管理',
                children: [
                  {
                      name: '优惠券发放',
                      url: '/auction/vouchers',
                      action: "auction/vouchers#index"

                  },
                  {
                      name: '发放优惠券',
                      url: '/auction/vouchers/new',
                      action: "auction/vouchers#new"

                  },
                ]
            },
            {
              grandfather: '运营管理',
              parent: '开机轮播图',
                children: [
                  {
                      name: '轮播图列表',
                      url: '/auction/carousels',
                      action: "auction/carousels#index"
                  },
                ]
            },
            {
              grandfather: '运营管理',
              parent: 'VIP管理',
                children: [
                  {
                      name: 'VIP列表',
                      url: '/auction/users',
                      action: "auction/users#index"
                  },
                  {
                      name: '新增VIP',
                      url: '/auction/users/new',
                      action: "auction/users#new"
                  },
                ]
            },
            {
              grandfather: '运营管理',
              parent: '活动管理',
              children: [
                {
                  name: '活动列表',
                  url: '/auction/promotion_activities',
                  action: "auction/promotion_activities#index"
                },
                {
                  name: '新增活动',
                  url: '/auction/promotion_activities/new',
                  action: "auction/promotion_activities#new"
                }
              ]
            },
            {
              grandfather: '运营管理',
              parent: '活动商品审批',
              children: [
                {
                  name: '活动商品审批',
                  url: '/auction/promotion_activity_applies',
                  action: "auction/promotion_activity_applies#index"
                }
              ]
            }

          ]
      }
    end

    # 供应商管理
    def self.providers_menus
      side_menus = {
          menu5: [
              {
                  grandfather: '供应商管理',
                  parent: '供应商管理',
                  children: [
                      {
                          name: '供应商列表',
                          url: '/manage/providers',
                          action: "manage/providers#index"
                      },
                      {
                          name: '新建帐号',
                          url: '/manage/providers/new',
                          action: "manage/providers#new"
                      }
                  ]
              },
              {
                  grandfather: '供应商管理',
                  parent: '结算管理',
                  children: [
                      {
                          name: '结算列表',
                          url: '/manage/report_forms',
                          action: "manage/report_forms#index"
                      },
                      {
                          name: '新建结算',
                          url: '/manage/report_forms/new',
                          action: "manage/report_forms#new"
                      },
                  ]
              },
          ]
      }
    end

    # 权限管理
    def self.permission_menus
      side_menus = {
          menu6: [
              {
                  grandfather: '权限管理',
                  parent: '权限管理',
                  children: [
                      {
                          name: '编辑列表',
                          url: '/manage/editors',
                          action: "manage/editors#index"
                      },
                      {
                          name: '角色列表',
                          url: '/manage/roles',
                          action: "manage/roles#index"
                      },
                      {
                          name: '基本权限',
                          url: '/manage/authorities',
                          action: "manage/authorities#index"
                      },
                  ]
              },
          ]
      }
    end


  end
end
