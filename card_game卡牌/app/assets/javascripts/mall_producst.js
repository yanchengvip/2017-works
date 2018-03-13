//添加奇珍商品form验证
function mall_products_form_validate(form) {
    a0 = form.elements["exchange_type0"].checked;
    a1 = form.elements["exchange_type1"].checked;
    t0 = form.elements["micro_ticket"].value;
    t1 = form.elements["micro_score"].value;
    if (a0 == false && a1 == false) {
        alertTX('通兑方式必选一个！')
        return false;
    }

    if (a0 == true && t0 == '') {
        alertTX('功勋数量不能为空！')
        return false;
    }

    if (a1 == true && t1 == '') {
        alertTX('微集分！')
        return false;
    }
    if (a0 == true) {
        $('#exchange_type_input').val(0)
    }
    if (a1 == true) {
        $('#exchange_type_input').val(1)
    }
    if (a0 == true && a1 == true) {
        $('#exchange_type_input').val(2)
    }
    is_img = validateImageForm()
    if (is_img == false) {
        return false;
    }

}