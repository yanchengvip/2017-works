data = [
    {
        trade_id: 1,
        supplier_trade_id: 1, #供应商订单ID
        identifier: 201705103288919, #订单号
        supplier_trade_identifier: 20170510822823889, #供应商订单号
        price: 100,
        payment_price: 100,
        created_at: 2017,
        status: 'pay',
        delivery_time: 'all',
        address: {
            name: '收货人',
            address: '收货地址',
            phone: '联系电话',
            postcode: '邮编'
        },
        units: [
            {
                unit_id: 1,
                product_id: 1,
                status: '',
                name: '风衣',
                pic: '图片',
                price: '市场价',
                discount: '销售价',
                percent: '折扣',
                amount: '购买数量',
                sku_id: 1,
                sku_name: 'sku名称 如：XL, XXL',
                sku_color: '红色',
                sku_code: 'sku编码'
            },
            {
                unit_id: 2,
                product_id: 2,
                status: '',
                name: '风衣',
                pic: '图片',
                price: '市场价',
                discount: '销售价',
                percent: '折扣',
                amount: '购买数量',
                sku_id: 1,
                sku_name: 'sku名称 如：XL, XXL',
                sku_color: '红色',
                sku_code: 'sku编码'
            }
        ]

    }
]
json.status 200
json.msg  '成功'
json.data data
