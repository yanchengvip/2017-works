$(document).on('turbolinks:load', function () {

    //战役号码位数选择框
    $("#bout_num_select").select2().on('select2:selecting', function (e) {
        var selected_val = e.params.args.data.id;
        if (selected_val == 0) {
            $("#set_card_rules").html('');
        } else {
            $.ajax({
                type: 'get',
                url: '/battle_rules/set_card_rule',
                data: {bout_number: selected_val},
                success: function (data) {
                    $("#set_card_rules").html(data)
                },
                error: function () {

                }
            })
        }


    });

    //战役规则礼包,选择礼包
    function add_package_for_form(index, data) {
        $('#name'+index).val(data['name'])
        $('#price'+index).val(data['price'])
        $('#package_id'+index).val(data['id'])
        $('#pt_name'+index).val(data['pt_name'])
        if($('#brp_id'+index).length > 0){
            $('#brp_id'+index).remove()
        }

    }

    $('#battle_rule_package_form').submit(function (e) {
        package_id = $(this).serialize()
        $.ajax({
            type: 'get',
            url: '/battle_rules/selected_rule_package',
            data: package_id,
            success: function (data) {
                switch (data['pt_name']) {
                    case '技巧包':
                        add_package_for_form(0, data);
                        break;
                    case '基础包':
                        add_package_for_form(1, data);
                        break;
                    case '高级包':
                        add_package_for_form(2, data);
                        break;
                    case '土豪包':
                        add_package_for_form(3, data);
                        break;

                }

            }
        })
        $('#rulePackageModal').modal('hide');
        return false;
    });
});

////添加战役规则form验证
function battle_rule_form_validate(form) {
    p1 = form.elements["open_person_number"].value;
    p2 = form.elements["max_person_number"].value;
    warn_phone = form.elements["warn_phone"].value;
    if (parseInt(p1) > parseInt(p2)) {
        alertTX('第一轮开启人数只能小于等于最大报名人数')
        return false;
    }
    if (!(/[0-9]([0-9]|,)$/.test(warn_phone))) {
        alertTX('接收报警手机格式不正确')
        return false;
    }
}

// 战役规则销售礼包modal
function battle_rule_package_modal(pt_name) {

    $('#rulePackageModal').modal('show');
    $('#rulePackageModal').on('shown.bs.modal', function () {
        console.log(pt_name)
        $.ajax({
            type: 'get',
            url: '/battle_rules/get_rule_packages',
            data: {pt_name: pt_name},
            success: function (data) {
                $('.modal_rule_package_table').html(data)
            }
        })
        $(this).off('shown.bs.modal');
    }).on('hidden.bs.modal', function () {
        $('.modal_rule_package_table').html('');
    })
}

