// 订单列表展开详情
function detailFormatter(index, row) {
    var $table = $('#table')
    var trade_id = row['0']
    var supplier_trade_id = row['1']
    is_suppiler_trade = trade_id.indexOf('</a>')

    if (is_suppiler_trade >= 0) {
        // 供应商订单
        trade_id = supplier_trade_id
        var type = 2
    } else {
        // 用户订单
        trade_id = trade_id
        var type = 1
    }

    $table.on('expand-row.bs.table', function (e, index2, row, $detail) {
        if (index2 == index) {
            $detail.html('Loading...');
            $.get('/auction/units/collapse_table?type='+type+'&id=' + trade_id, function (res) {
                $detail.html(res);
            });
        }
    });
}

function supplierTradeDetail(index, row) {
    var $table = $('#table')
    var supplier_trade_id = row['0']
    $table.on('expand-row.bs.table', function (e, index2, row, $detail) {
        if (index2 == index) {
            $detail.html('Loading...');
            $.get('/auction/units/collapse_table?type=2&id=' + supplier_trade_id, function (res) {
                $detail.html(res);
            });
        }
    });
}


// 退货管理操作记录的 modal
function returnRecordsModal() {
    $('#returnRecordsModal').modal('show')
    show_return_records_modal(1)
}
// 退货管理操作记录的 modal显示内容
function show_return_records_modal(type) {
    $('.srm_btn').removeClass('active');
    $('.srm_btn' + type).addClass('active');
    var url = ''
    if (type == 1) url = '/auction/supplier_trades/return_status_records';
    if (type == 2) url = '/auction/supplier_trades/pay_records';
    if (type == 3) url = '/auction/supplier_trades/return_pay_records';
    $.ajax({
        type: 'get',
        url: url,
        success: function (res) {
            $('#return-records-content').html(res)
        },
        error: function (err) {
            $('#return-records-content').html('网络异常，稍后重试!')
        },
        beforeSend: function () {
            $('#return-records-content').html('Loading...')
        }

    })
}