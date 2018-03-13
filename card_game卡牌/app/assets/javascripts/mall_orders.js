//页面切换 重新加载此js,取消turbolinks
$(document).on('turbolinks:load', function () {
    $("#dowload").hover(function(){
        $("#dowload").text("导出csv,导出条件为时间");
    },function(){
        $("#dowload").text("导出csv");
    });
    //统计月份
    $('.csv_datepicker').val(moment().format('YYYY-MM'))
    $('.csv_datepicker').datetimepicker({
        format: 'YYYY-MM',
        locale: 'zh-cn'
    }).on('dp.change', function (ev) {

    });

    //查询注册开始时间
    $('.csv_start_datetimepicker').datetimepicker({
        format: 'YYYY-MM-DD',
        locale: 'zh-cn'
    }).on('dp.change', function (ev) {

    });
    ;

    //查询注册结束时间
    $('.csv_end_datetimepicker').datetimepicker({
        format: 'YYYY-MM-DD',
        locale: 'zh-cn'
    }).on('dp.change', function (ev) {

    });

});

function dowload_csv(type) {
    d1 = {
        'csv_start_datetimepicker': $('.datetime_picker_battle1').val(),
        'csv_end_datetimepicker': $('.datetime_picker_battle2').val()
    }
    switch (type) {
        case 1:
            url = '/download_csv/order_info_csv';
            d2 = {
                "created_at_begin": $('.datetime_picker_battle1').val(),
                'created_at_end': $('.datetime_picker_battle1').val(),
                'product_name': $('#product_name').val(),
                'status': $('#status').val(),
                'mobile': $('#mobile').val()
            }
            data = $.extend(d1,d2)
            downlod_csv(url, data)
            break;
        case 2:
            url = '/download_csv/winning_order_info_csv';
            d2 = {
                "created_at_begin": $('.datetime_picker_battle1').val(),
                'created_at_end': $('.datetime_picker_battle2').val(),
                'battle_code': $('#battle_code').val(),
                'good_name': $('#good_name').val(),
                'mobile': $('#mobile').val(),
                'claim_status': $('#claim_status').val(),
                'shipping_status': $('#shipping_status').val()
            }
            data = $.extend(d1, d2)
            downlod_csv(url, data)
            break;
        case 3:
            url = '/download_csv/battle_card_info_csv'
            d2 = {
              "published_at_begin": $('.datetime_picker_battle1').val(),
              'published_at_begin': $('.datetime_picker_battle2').val(),
              'battle_code': $('#battle_code').val(),
              'name': $('#name').val(),
              'status': $('#status').val(),
              'battle_product_id': $('#battle_product_id').val(),
              'battle_rule_id': $('#battle_rule_id').val()
            }
            data = $.extend(d1, d2)
            downlod_csv(url, data)
            break;
        case 4:
            url = '/download_csv/user_info_csv'
            d2 = {
              "create_time_begin": $('.datetime_picker_battle1').val(),
              'create_time_end': $('.datetime_picker_battle2').val()
            }
            data = $.extend(d1, d2)
            downlod_csv(url, data)
            break;
        case 5:
            url = '/download_csv/user_card_info_csv'
            d2 = {
              "create_time_begin": $('.datetime_picker_battle1').val(),
              'create_time_end': $('.datetime_picker_battle2').val()
            }
            data = $.extend(d1, d2)
            downlod_csv(url, data)
            break;
        case 6:
            url = '/download_csv/user_calculus_change'
            d2 = {
              "create_time_begin": $('.datetime_picker_battle1').val(),
              'create_time_end': $('.datetime_picker_battle2').val()
            }
            data = $.extend(d1, d2)
            downlod_csv(url, data)
            break;
        default:


    }


}

function downlod_csv(url, data) {
    $.ajax({
        type: 'get',
        dataType: 'json',
        contentType: "application/json",
        url: url,
        data: data,
        success: function (data) {
            alert('导出成功后,请到【报表】拷贝文件')
        }
    })
}
