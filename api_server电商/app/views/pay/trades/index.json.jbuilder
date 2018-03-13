data = {
    identifier: '222222222',
    price: '',
    status: '',
    units: [
        {
            name: "风衣",
            discount: "销售价",
            amount: "购买数量",
        },
        {
            name: "风衣",
            discount: "销售价",
            amount: "购买数量",
        }
    ],
    payment_services: @payment_services

}

json.status 200
json.msg '成功'
json.data data