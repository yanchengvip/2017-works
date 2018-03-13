module Menus
  module HeaderMenus
    def self.list
      [
          {
              children: [
                  {
                      name: '内容管理',
                      url: '/auction/pic_ads',
                      action: "auction/pic_ads#index"
                  },
                  {
                      name: '商品管理',
                      url: '/auction/products',
                      action: "auction/products#index"
                  },
                  {
                      name: '订单管理',
                      url: '/auction/trades',
                      action: "auction/trades#index"
                  },
                  {
                      name: '运营管理',
                      url: '/auction/events',
                      action: "auction/events#index"
                  },
                  {
                      name: '供应商管理',
                      url: '/manage/providers',
                      action: "manage/providers#index"
                  },
                  {
                      name: '权限管理',
                      url: '/manage/authorities',
                      action: "manage/authorities#index"
                  }
              ]
          }
      ]
    end
  end
end