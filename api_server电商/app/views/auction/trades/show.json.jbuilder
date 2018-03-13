data =
    {
        trade_id: 1,#订单ID
        supplier_trade_id: 1,#供应商订单ID
        identifier: 201705108899, #订单号
        supplier_trade_identifier: 2017051088889,
        price: 100, #市场价
        payment_price: 100, #付款价格
        payment_service: 'express',#付款方式
        created_at: '2017-08-09',
        status: 'pay',
        delivery_time: 'all', #workday=工作日, playday = 休息日, all = 皆可
        comment: '留言', #留言
        total_unit: 2, #订单商品总数量
        is_allow_return: false, #是否能退货 trade.status == 'complete' && (Time.now - created_at) <= 30
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
                price: 100, #市场价
                discount: 100, #折扣价
                percent: '', #折扣
                amount: 1,
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
                price: 100, #市场价
                discount: 100, #折扣价
                percent: '', #折扣
                amount: 1,
                sku_id: 1,
                sku_name: 'sku名称 如：XL, XXL', #XXL
                sku_color: '红色',
                sku_code: 'sku编码'
            }
        ]

    }

json.status 200
json.msg  '成功'
json.data data
