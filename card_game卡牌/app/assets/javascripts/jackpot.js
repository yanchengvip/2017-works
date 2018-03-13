$(document).on('turbolinks:load', function () {
  $('body').on('change', '.level', function(){
    var sl_val = $(this).val()
    ele = $(this)
    console.log(sl_val)
    if(!!sl_val && sl_val == 1){
      $(this).parent().next().next().children('.prize_num').val(1).attr('readonly', true)
      $(this).parent().next().next().next().text(1)
      // $(this).parent().nextAll('.user_td').children('.user_id').attr('readonly', false)
    }else{
      $(this).parent().next().next().children('.prize_num').val(1).attr('readonly', false)
      // $(this).parent().nextAll('.user_td').children('.user_id').attr('readonly', true)
    }
  })

  $('body').on('change', '.chest_prize', function(){
    var sl_val = $(this).val()
    ele = $(this)
    console.log(sl_val)
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: "/chest_boxs/get_prize",
        data: {prize_id: sl_val},
        success: function(result){
          // $('#silk_bag_card_div').html(result)
          console.log(result.data.price)
          ele.parent().next().children('.price').val(result.data.price)
          ele.parent().nextAll('.worth_td').children('.worth').val(result.data.price * ele.parent().next().children('.prize_num').val() * 1)
        },
        error: function(XMLHttpResponse){
          elert('网络错误')
        }
      })
    }
  })

  $('body').on('keyup', '.prize_num', function(){
    var price = $(this).prev().val()
    var num = $(this).val()
    console.log(price)
    $(this).parent().next().text(num)
    $(this).parent().next().next().children('.worth').val(num * price)
  })

  $('body').on('click', '.add_jackpot_product', function(){
    ele = $(this)
    var treasure_box_id = $('#treasure_box_id').val()
    var pid = $(this).prev().val()
    console.log(pid)
    $.ajax({
      type: 'get',
      url: "/treasure_boxs/"+treasure_box_id+"/get_product",
      data: {pid: pid},
      success: function(result){
        // $('#level3_product_content').html(result)
        ele.parents('tr').next('tr').children('td.content').html(result)
      },
      error: function(XMLHttpResponse){
        elert('网络错误')
      }
    })
  })

  $('body').on('click', '.del_level_new', function(){
    $(this).parents("div.content_tr").remove()
  })

  // $("#new_jackpot").on('click', function(){
  //   var has_master = $('#has_master').val()
  //   console.log(has_master == 0)

  //   $.ajax({
  //     type: 'get',
  //     url: "/treasure_boxs/"+$("#treasure_box_id").val()+"/get_jackpot_form",
  //     data: {},
  //     success: function(result){
  //       $('#silk_bag_card_div').html(result)
  //     },
  //     error: function(XMLHttpResponse){
  //       elert('网络错误')
  //     }
  //   })
  // })

  $('.add_new_level2_product').on('click', function(){
    var treasure_box_id = $('#treasure_box_id').val()
    $.ajax({
      type: 'get',
      url: '/treasure_boxs/'+treasure_box_id+'/level2_type',
      data: { random_id: 'l2' + Number($('#level2_random_id').text())},
      success: function(result){
        $('#level2_product_div').append(result)
      },
      error: function(XMLHttpResponse){
        alert('添加失败')
      }
    })
    $('#level2_random_id').text(Number($('#level2_random_id').text()) + 1)
  })

  $('.add_new_level1_product').on('click', function(){
    var treasure_box_id = $('#treasure_box_id').val()
    $.ajax({
      type: 'get',
      url: '/treasure_boxs/'+treasure_box_id+'/level1_type',
      data: { random_id: 'l1' + Number($('#level1_random_id').text())},
      success: function(result){
        $('#level1_product_div').append(result)
      },
      error: function(XMLHttpResponse){
        alert('添加失败')
      }
    })
    $('#level1_random_id').text(Number($('#level1_random_id').text()) + 1)
  })

  $('body').on('keyup', '.prize_num', function(){
    // console.log($(this).val())
    // console.log($(this).prev().prev().val())
    $(this).next().next().text($(this).val() * $(this).prev().prev().val())
    calc_all_num_and_fund()
  })

  $('body').on('keyup', '.prize_fund', function(){
    $(this).parent().children('.level_fund_all').text($(this).val() * $(this).next().next().val())
    calc_all_num_and_fund()
  })

  $('.submit_stage').on('click', function(){
    // var out_prize = $(this).parents('p')
    // var out_worth =1
    // console.log()
  })

  $('#chest_box_submit').on('click', function(){
    var chest_type = $('#chest_box_chest_type').val() * 1
    var prize_min = $('#chest_box_prize_min').val() * 1
    var prize_max = $('#chest_box_prize_max').val() * 1
    if(prize_min > prize_max){
      elert('最小商品数必须小于最大商品数')
      return false
    }

    var hands = $('#chest_box_hands').val() * 1
    var total_num = 0
    $('.prize_num').each(function(index, el) {
      if($(el).hasClass('appoint_num')){
        total_num += $(el).val() * 1 * hands
      }else{
        total_num += $(el).val() * 1
      }
    });

    if(total_num < prize_min * hands && (chest_type != 7 && chest_type != 8)){
      elert('奖品总数量必须大于手数乘以最小商品个数的值')
      return false
    }
    console.log(total_num)
    if(total_num > prize_max * hands && (chest_type != 7 && chest_type != 8)){
      elert('奖品总数量必须小于手数乘以最大商品个数的值')
      return false
    }

    var out_prize_sum = 0
    var out_prize_worth = 0
    $('.out_prize').each(function(index, el) {
      out_prize_sum += $(el).val() * 1
    });
    console.log(out_prize_sum)
    $('.out_worth').each(function(index, el) {
      out_prize_worth += $(el).val() * 1
    });
    console.log(out_prize_worth)

    if(out_prize_sum != 100 || out_prize_worth != 100){
      elert('所有阶段产出奖品百分比之和和产出价值百分比之和必须分别等于100')
      return false
    }

    var big = 0
    $('.level').each(function(index, el) {
      if($(el).val() == 1){
        big += 1
      }
    });
    console.log(big)

    if(big != 1 && chest_type != 6 && chest_type != 7 && chest_type != 8){
      elert('幸运大奖有且只能有 1 个！')
      return false
    }

    var arr = new Array()
    $('.random_prize').each(function(index, el) {
      arr.push($(el).val())
    });
    var new_arr = arr.sort();
    var prize_flag = true
    for(var i=0; i<arr.length; i++){
      if (new_arr[i] == new_arr[i+1]){
        prize_flag = false
      }
    }
    if(!prize_flag){
      elert('随机奖品商品不能重复！')
      return false
    }

    // var odds_sum = 0
    // $('.virtual_odds').each(function(index, el) {
    //   odds_sum += $(el).val() * 1
    // });
    // if(odds_sum != 100 && chest_type == 5){
    //   elert('app注册虚拟奖品的概率之和必须等于100')
    //   return false
    // }


  })

  $('.chest_prize_type').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    if(!!sl_val && sl_val == 6){
      $('.event_div').removeClass('hide')
    }else{
      $('.event_div').addClass('hide')
    }
  })

  $('#chest_box_chest_type').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    var arr = [5, 6, 7, 8];
    if(!!sl_val && sl_val == 5){
      console.log(111)
      $('#normal_prize, #app_prize').removeClass('hide')
      $('#h5_prize, #cash_random_prize, #cash_fix_prize').addClass('hide')
    }else if(sl_val == 6){
      console.log(222)
      $('#h5_prize').removeClass('hide')
      $('#normal_prize, #app_prize, #cash_random_prize, #cash_fix_prize').addClass('hide')
    }else if(sl_val == 7){
      $('#cash_fix_prize').removeClass('hide')
      $('#normal_prize, #app_prize, #h5_prize, #cash_random_prize').addClass('hide')
    }else if(sl_val == 8){
      $('#cash_random_prize').removeClass('hide')
      $('#normal_prize, #app_prize, #h5_prize, #cash_fix_prize').addClass('hide')
    }
    else if($.inArray(sl_val, arr) == -1){
      console.log(333)
      $('#normal_prize').removeClass('hide')
      $('#h5_prize, #app_prize, #cash_random_prize, #cash_fix_prize').addClass('hide')
    }


  })

  $('#chest_prize_submit').on('click', function(){
    var prize_type = $('#chest_prize_prize_type').val()
    var event_id = $('#chest_prize_event_id').val()
    console.log(prize_type)
    if(prize_type == 6){
      if(event_id == 0 || event_id == ''){
        elert('奖品类型为现金券时，必须填写对应的券ID')
        $('#chest_prize_event_id').focus()
        return false
      }
    }

    var phone_fee = $('#chest_prize_num').val()
    var fee_arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 30, 50, 100, 200, 300, 500]
    if(prize_type == 7 && $.inArray(phone_fee * 1, fee_arr) == -1){
      elert('话费充值只能填固定数值')
      $('#chest_prize_num').focus()
      return false
    }

  })

  $('.side_menu_list').on('click', function(){
    console.log($(this).attr('id'))
    var sid = $(this).attr('id').split('_')[3]
    document.cookie = "side_bg=" + sid
  })

  $('#new_chest_box_submit').on('click', function(){
    var big = 0
    $('.level').each(function(index, el) {
      if($(el).val() == 1){
        big += 1
      }
    });
    if(big > 0){
      elert('幸运大奖有且只能有 1 个！')
      return false
    }

    var hands = $('#chest_box_hands').val() * 1
    // var prize_min = $('#chest_box_prize_min').val()
    var prize_max = $('#chest_box_prize_max').val() * 1
    var total_num = $('#chest_box_total_num').val() * 1
    console.log(total_num)
    $('.prize_num').each(function(index, el) {
      total_num += $(el).val() * 1
    });
    // if(total_num < prize_min * hands){
    //   elert('奖品总数量必须大于手数乘以最小商品个数的值')
    //   return false
    // }
    console.log(total_num)
    if(total_num > prize_max * hands){
      elert('奖品总数量必须小于手数乘以最大商品个数的值')
      return false
    }
  })

  $('#mammon_period_submit').on('click', function(){
    var begin_time = getDate($('#mammon_period_pre_begin_time').val())
    var end_time = getDate($('#mammon_period_end_time').val())
    if(begin_time >= end_time){
      elert('准备开始时间必须小于结算时间！')
      return false
    }

  })




})

function calc_all_num_and_fund(){
  var num = 0
  var fund = 0
  $('.prize_num').each(function(index, el) {
    num += $(el).val() * 1
  });
  $('#current_prize_num').val(num)
  $('.level_fund_all').each(function(index, el) {
    fund += $(el).text() * 1
  });
  $('#current_prize_fund').val(fund)
}

// 启用、停用
function chest_box_shelf(chest_box_id, status){
  $('#shelfChestBoxModal').modal('show')
  $('#shelfChestBoxModal').on('shown.bs.modal',function(){
    // $('#shelf_game_type_name').html(game_type_name)
    $('#shelf_chest_box_id').val(chest_box_id)
    $('#shelf_chest_box_status').val(status)
    var str = status == 1 ? '启用' : '停用'
    $('#shelf_status, #shelf_title').text(str)
  })
}

// 顶部广播启用、停用
function chest_broadcast_shelf(chest_broadcast_id, status){
  $('#shelfChestBroadcastModal').modal('show')
  $('#shelfChestBroadcastModal').on('shown.bs.modal',function(){
    // $('#shelf_game_type_name').html(game_type_name)
    $('#shelf_chest_broadcast_id').val(chest_broadcast_id)
    $('#shelf_chest_broadcast_status').val(status)
    var str = status == 1 ? '启用' : '停用'
    $('#shelf_status, #shelf_title').text(str)
  })
}

//
function chest_order_confirm(chest_order_id, status, from){
  $('#confirmChestOrderModal').modal('show')
  $('#confirmChestOrderModal').on('shown.bs.modal',function(){
    // $('#shelf_game_type_name').html(game_type_name)
    $('#confirm_chest_order_id').val(chest_order_id)
    $('#confirm_chest_order_status').val(status)
    $('#confirm_from').val(from)
    var str = status == 1 ? '充值' : '取消充值'
    $('#confirm_status, #confirm_title').text(str)
  })
}

// 删除等级
function level_delete(glutton_level_id){
  $('#deleteGlLevelModal').modal('show');
  $('#deleteGlLevelModal').on('shown.bs.modal',function(){
    $('#del_level_id').val(glutton_level_id)
  })
}

// 实物发货
function chest_ship(chest_record_id){
  $('#shipChestModal').modal('show')
  $('#shipChestModal').on('shown.bs.modal',function(){
    $('#ship_chest_record_id').val(chest_record_id)
    $.ajax({
      type: 'get',
      url: '/chest_records/'+chest_record_id+'/get_ship_info',
      data: { },
      success: function(result){
        $('#ship_div').html(result)
      },
      error: function(XMLHttpResponse){
        alert('操作失败')
      }
    })
  })
}

// 发券
function grant_voucher(chest_record_id){
  $('#grantVoucherModal').modal('show')
  $('#grantVoucherModal').on('shown.bs.modal',function(){
    $('#grant_voucher_id').val(chest_record_id)
  })
}

//
function copy_chest_box(chest_box_id){
  $('#copyChestModal').modal('show')
  $('#copyChestModal').on('shown.bs.modal',function(){
    $('#copy_chest_box_id').val(chest_box_id)
  })
}

// 删除奖品
function chest_prize_delete(chest_prize_id,chest_prize_name){
  $('#deleteChestPrizeModal').modal('show');
  $('#deleteChestPrizeModal').on('shown.bs.modal',function(){
    $('#del_chest_prize_name').html(chest_prize_name)
    $('#del_chest_prize_id').val(chest_prize_id)
  })
}

//
function mall_order_recharge_confirm(mall_order_id, status, from){
  $('#confirmRechargePhoneOrderModal').modal('show')
  $('#confirmRechargePhoneOrderModal').on('shown.bs.modal',function(){
    $('#confirm_mall_order_id').val(mall_order_id)
    $('#confirm_mall_order_status').val(status)
    $('#confirm_from').val(from)
    var str = status == 1 ? '充值' : '取消充值'
    $('#confirm_status, #confirm_title').text(str)
  })
}

//
function recharge_reconfirm(recharge_id, status, from){
  $('#reconfirmRechargePhoneOrderModal').modal('show')
  $('#reconfirmRechargePhoneOrderModal').on('shown.bs.modal',function(){
    $('#reconfirm_rechare_id').val(recharge_id)
    $('#reconfirm_recharge_status').val(status)
    $('#confirm_from').val(from)
    var str = status == 1 ? '充值' : '取消充值'
    $('#confirm_status, #confirm_title').text(str)
  })
}

// 红包规则启用、停用
function red_package_rule_shelf(red_package_rule_id, status){
  $('#shelfRedPackageRuleModal').modal('show')
  $('#shelfRedPackageRuleModal').on('shown.bs.modal',function(){
    // $('#shelf_game_type_name').html(game_type_name)
    $('#shelf_red_package_rule_id').val(red_package_rule_id)
    $('#shelf_red_package_rule_status').val(status)
    var str = status == 0 ? '启用' : '禁用'
    $('#shelf_status, #shelf_title').text(str)
  })
}

// 联赛启用、停用
function game_league_shelf(game_league_id, status){
  $('#shelfGameLeagueModal').modal('show')
  $('#shelfGameLeagueModal').on('shown.bs.modal',function(){
    $('#shelf_game_league_id').val(game_league_id)
    $('#shelf_game_league_status').val(status)
    var str = status == 1 ? '启用' : '停止'
    $('#shelf_status, #shelf_title').text(str)
  })
}

//
function copy_game_league(game_league_id){
  $('#copyGameLeagueModal').modal('show')
  $('#copyGameLeagueModal').on('shown.bs.modal',function(){
    $('#copy_game_league_id').val(game_league_id)
  })
}
