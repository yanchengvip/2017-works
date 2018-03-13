$(document).on('turbolinks:load', function () {
    //创建战役时间设置
    $("#datetime_picker").datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
        defaultDate: moment().add(1, 'hour').format('YYYY-MM-DD HH:mm'),
    })
    $(".datetime_picker").datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
        defaultDate: moment().add(1, 'hour').format('YYYY-MM-DD HH:mm'),
    })
    $('#begin_time_picker').datetimepicker({
        format: 'HH:mm',
        locale: 'zh-cn',
        defaultDate: moment('2016-06-13 10:00').format('YYYY-MM-DD HH:mm')
    });
    $('#end_time_picker').datetimepicker({
        format: 'HH:mm',
        locale: 'zh-cn',
        defaultDate: moment('2016-06-13 20:00').format('YYYY-MM-DD HH:mm')
    });

    $('.datetime_picker_before').datetimepicker({
        useCurrent: false,
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
        defaultDate: moment().add(1, 'hour').format('YYYY-MM-DD HH:mm'),
        minDate: moment().format('YYYY-MM-DD HH:mm'),
    })


    $('.datetime_picker_battle1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn'
    });
    $('.datetime_picker_battle2').datetimepicker({
        useCurrent: false, //Important! See issue #1075
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn'
    });
    $(".datetime_picker_battle1").on("dp.change", function (e) {
        $('.datetime_picker_battle2').data("DateTimePicker").minDate(e.date);
    });



    //战役失败礼包 战役结束后战役失败用户赠送规则
    $('#battle_add_package_fail_form').submit(function (e) {
        package_ids = $(this).serialize()
        $.ajax({
            type: 'get',
            url: '/battles/battle_package_tr_fail',
            data: package_ids,
            success: function (data) {
                $('#battle_package_table_fail').append(data)
                $('#newBattleSelectRuleFailModal').modal('hide');
            }
        });
        return false;
    });


    //战役兑换礼包,选择礼包
    $('#battle_add_package_form').submit(function (e) {
        package_ids = $(this).serialize()
        $.ajax({
            type: 'get',
            url: '/battles/battle_package_tr',
            data: package_ids,
            success: function (data) {
                $('#battle_package_table').append(data)
                $('#newBattleSelectRuleModal').modal('hide');
            }
        });
        return false;
    });



});

// 战役胜利兑换礼包modal
function battle_package_win_modal() {
    $('#newBattleSelectRuleModal').modal('show');
    $('#newBattleSelectRuleModal').on('shown.bs.modal', function () {
        $.ajax({
            type: 'get',
            url: '/battles/battle_package_table',
            success: function(data){
                $('.modal_battle_rule_table').html(data)
            }
        })
        $(this).off('shown.bs.modal');
    }).on('hidden.bs.modal',function(){
        $('.modal_battle_rule_table').html('');
    })

}


// 战役失败获赠的礼包modal
function battle_package_fail_modal() {
    $('#newBattleSelectRuleFailModal').modal('show');
    $('#newBattleSelectRuleFailModal').on('shown.bs.modal', function () {
        $.ajax({
            type: 'get',
            url: '/battles/battle_package_table',
            success: function(data){
                $('.modal_battle_rule_table').html(data)
            }
        })
        $(this).off('shown.bs.modal');
    }).on('hidden.bs.modal',function(){
        $('.modal_battle_rule_table').html('');
    })

}

function search_bp() {

    var bp_id = $('#bp_id').val();
    if (!bp_id || bp_id == 'undefined') {
        alert('商品ID不能为空')
        return false
    }
    $.ajax({
        type: 'get',
        url: '/battles/search_bp',
        data: {bp_id: bp_id},
        success: function (result) {
            $('#search_add_bp_tbody').html(result)
        },
        error: function () {
            alert('添加战役商品出错了')
        }
    })

}

//添加战役form验证
function battle_form_validate(form) {
    a1 = form.elements["award_setting1"].checked;
    a2 = form.elements["award_setting2"].checked;
    a3 = form.elements["award_setting3"].checked;
    micro = form.elements["exchange_micro_ticket"].value;
    time_radio = $('#published_at_radio').is(':checked');
    battle_rule_id = form.elements["battle_rule_id"].value;
    if (battle_rule_id == 0){
        alertTX('战役规则不能为空！')
        return false
    }

    if (a1 == false && a2 == false && a2 == false) {
        alertTX('【领奖设置】必填实物或奖品兑换！')
        return false;
    }
    if (!$('#bp_id_val').val()) {
        alertTX('战役商品不能为空！')
        return false;
    }


    if (a2 == true && micro == '') {
        alertTX('【领奖设置】选中奖品兑换，功勋数量不能为空！')
        return false;
    }

    if (a3 == true && !$('.package_id').val()){
        alertTX('【领奖设置】选中兑换成卡牌，礼包不能为空！')
        return false;
    }

    if (!$('.package_micro_score').val()){
        alertTX('战役失败用户赠送礼包，礼包不能为空！')
        return false;
    }

    if(time_radio){
        t1 = $('#datetime_picker_before').val()
        t2 = moment().format('YYYY-MM-DD HH:mm')
        if (t1 < t2){
            alertTX('发布时间不能小于当前时间！')
            return false;
        }
    }

    is_img = validateImageForm()
    if (is_img == false) {
        return false;
    }

}

//删除战役table的tr
function delBattlePackageTr(tr_id){
    $("#"+tr_id).remove();
}

//计算礼包价值
function countBPackagePrice(num,price,total_id){
    total_price = parseInt(num.value) * parseFloat(price)
    $('#'+total_id).val(total_price)
}

