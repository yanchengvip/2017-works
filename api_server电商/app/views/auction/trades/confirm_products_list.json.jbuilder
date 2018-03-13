data = [
    {
        product_id: 1,
        price: 1000,#市场价
        discount: 1000, #销售价
        product_name: '土豪版上衣',
        product_color: '黑色',
        product_pic: 'http://i3.ihaveu.net/image/auction/product/000/120/963/major_pic/c6e77be8.jpg.m78.jpg',
        sku: {
            id: 1,
            name: 'XL'
        },
        voucher: [
            {
                id: 1, #auction_vouchersID
                event_id: 1, #优惠券auction_eventID
                name: '优惠券名称1',
                amount: 10, #优惠金额
                limitation: 500, #限制金额
                description: '描述'
            },
            {
                id: 2, #auction_vouchersID
                event_id: 2, #优惠券auction_eventID
                name: '优惠券名称2',
                amount: 30, #优惠金额
                limitation: 1000, #限制金额
                description: '描述'
            },
            # {
            #     id: 3, #auction_vouchersID
            #     event_id: 3, #优惠券auction_eventID
            #     name: '优惠券名称3',
            #     amount: 10, #优惠金额
            #     limitation: 500, #限制金额
            #     description: '描述'
            # },
            # {
            #     id: 4, #auction_vouchersID
            #     event_id: 4, #优惠券auction_eventID
            #     name: '优惠券名称4',
            #     amount: 30, #优惠金额
            #     limitation: 1000, #限制金额
            #     description: '描述'
            # },
            # {
            #     id: 5, #auction_vouchersID
            #     event_id: 3, #优惠券auction_eventID
            #     name: '优惠券名称3',
            #     amount: 10, #优惠金额
            #     limitation: 500, #限制金额
            #     description: '描述'
            # },

        ],
        level: {
            id: 2,#用户等级ID
            name: '白金',
            icon: 'http://i3.ihaveu.net/image/auction/level/000/000/002/icon/a2ca5877.png',
            limitation: 500,
            percent: 40,#折扣
        }


    },
    {
        product_id: 2,
        price: 440,#市场价
        discount: 440, #销售价
        product_name: '土豪版裤子',
        product_color: '黑色',
        product_pic: 'http://i3.ihaveu.net/image/auction/product/000/120/963/major_pic/c6e77be8.jpg.m78.jpg',
        sku: {
            id: 1,
            name: 'XL'
        },
        voucher: [
            {
                id: 5, #auction_vouchersID
                event_id: 3, #优惠券auction_eventID
                name: '优惠券名称3',
                amount: 10, #优惠金额
                limitation: 100, #限制金额
                description: '描述'
            }
        ],
        level: {
            id: 2,#用户等级ID
            name: '白金',
            icon: 'http://i3.ihaveu.net/image/auction/level/000/000/002/icon/a2ca5877.png',
            limitation: 500,
            percent: 40,#折扣
        }


    },
    {
        product_id: 3,
        price: 1000,#市场价
        discount: 1000, #销售价
        product_name: '土豪版上衣2',
        product_color: '黑色',
        product_pic: 'http://i3.ihaveu.net/image/auction/product/000/120/963/major_pic/c6e77be8.jpg.m78.jpg',
        sku: {
            id: 1,
            name: 'XL'
        },
        voucher: [
            {
                id: 1, #auction_vouchersID
                event_id: 1, #优惠券auction_eventID
                name: '优惠券名称1',
                amount: 10, #优惠金额
                limitation: 500, #限制金额
                description: '描述'
            },
            {
                id: 2, #auction_vouchersID
                event_id: 2, #优惠券auction_eventID
                name: '优惠券名称2',
                amount: 30, #优惠金额
                limitation: 1000, #限制金额
                description: '描述'
            },
            # {
            #     id: 3, #auction_vouchersID
            #     event_id: 3, #优惠券auction_eventID
            #     name: '优惠券名称3',
            #     amount: 10, #优惠金额
            #     limitation: 500, #限制金额
            #     description: '描述'
            # },
            # {
            #     id: 4, #auction_vouchersID
            #     event_id: 4, #优惠券auction_eventID
            #     name: '优惠券名称4',
            #     amount: 30, #优惠金额
            #     limitation: 1000, #限制金额
            #     description: '描述'
            # },
            # {
            #     id: 5, #auction_vouchersID
            #     event_id: 3, #优惠券auction_eventID
            #     name: '优惠券名称3',
            #     amount: 10, #优惠金额
            #     limitation: 500, #限制金额
            #     description: '描述'
            # }
        ],
        level: {
            id: 2,#用户等级ID
            name: '白金',
            icon: 'http://i3.ihaveu.net/image/auction/level/000/000/002/icon/a2ca5877.png',
            limitation: 500,
            percent: 40,#折扣
        }


    },
    {
        product_id: 4,
        price: 300,#市场价
        discount: 300, #销售价
        product_name: '土豪版上衣4',
        product_color: '黑色',
        product_pic: 'http://i3.ihaveu.net/image/auction/product/000/120/963/major_pic/c6e77be8.jpg.m78.jpg',
        sku: {
            id: 1,
            name: 'XL'
        },
        voucher: [
            {
                id: 1, #auction_vouchersID
                event_id: 1, #优惠券auction_eventID
                name: '优惠券名称1',
                amount: 10, #优惠金额
                limitation: 100, #限制金额
                description: '描述'
            }
        ],
        level: {
            id: 2,#用户等级ID
            name: '白金',
            icon: 'http://i3.ihaveu.net/image/auction/level/000/000/002/icon/a2ca5877.png',
            limitation: 500,
            percent: 40,#折扣
        }


    }
]


json.status 200
json.msg '成功'
json.data data