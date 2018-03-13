$(document).on('turbolinks:load', function () {
  $(".game_select2").select2()

  $('#game_type_game_product_tag_id').on('change', function(){
    var init_product_tag_id = $('#init_product_tag_id').val()
    var sl_val = $(this).val()
    if(init_product_tag_id > 0 && sl_val != init_product_tag_id){
      var game_type_id = $('#game_type_id').val()
      $.ajax({
        type: 'post',
        url: "/game_types/" + game_type_id + "/change_product_tag",
        data: {},
        success: function(result){
          if(result.status == 200){
            $('#chosed_product_div').html('')
            elert('你修改了商品类型，之前配置的商品已删除，请重新配置！')
          }else{
            elert('选择失败')
            window.location.reload()
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
          window.location.reload()
        }
      })
    }
  })

  $('#config_product').on('click', function(){
    if(!$('#game_type_game_product_tag_id').val()){
      elert('必须先选择商品类型！')
      return false
    }
    $('#config_radio').click()
    $.ajax({
      type: 'get',
      url: '/game_types/get_this_tag_products',
      data: { game_product_tag_id: $('#game_type_game_product_tag_id').val() },
      success: function(result){
        $('#product_modal_body').html(result)
        $('#choseBattleProductModal').modal('show')
      },
      error: function(XMLHttpResponse){
        alert('配置失败')
      }
    })
  })

  $('body').on('click', '.item_content_tr', function(){
    var product_id = $(this).attr('id').split('_')[2]
    $('#check_box_' + product_id).click()
  })

  $('body').on('click', '.product_chose_box', function(){
    var chosed_count = parseInt($($('#modal_product_count')[0]).text())
    if($(this).is(':checked')){
      $('#modal_product_count,#chosed_count').text(chosed_count + 1)
    }else{
      if(chosed_count > 0){
        $('#modal_product_count,#chosed_count').text(chosed_count - 1)
      }
    }
  })

  // 规则
  $('#game_type_game_rule_id').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    if(sl_val == ''){
      elert('必须选择赛场规则')
      return false
    }

    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/game_types/get_chosed_game_rule',
        data: {game_rule_id: sl_val},
        success: function(result){
          $('#chosed_game_rule_div').html(result)
        },
        error: function(XMLHttpResponse){
          alert('选择失败')
        }
      })

      var game_type_id = $('#for_game_type_id').val()
      $.ajax({
        type: 'get',
        url: '/game_types/round_card_form',
        data: {game_rule_id: sl_val, game_type_id: game_type_id},
        success: function(result){
          $('#for_choose_card_bag_div').html(result)
        },
        error: function(XMLHttpResponse){
          alert('网络异常1')
        }
      })

    }
  })

  // 卡包
  $('#game_type_card_bag_id').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/game_types/get_chosed_card_bag',
        data: {card_bag_id: sl_val},
        success: function(result){
          $('#chosed_card_bag_div').html(result)
        },
        error: function(XMLHttpResponse){
          alert('选择失败')
        }
      })
    }
  })

  // $('.card_bag_select').on('change', function(){
  $('body').on('change', '.card_bag_select', function(){
    var sl_val = $(this).val()
    ele = $(this)
    ele_id = $(this).attr('id').split('_')[3]
    var attack_ratio = $('#attack_ratio_' + ele_id).val()
    var guard_ratio = $('#guard_ratio_' + ele_id).val()
    var control_ratio = $('#control_ratio_' + ele_id).val()
    console.log(attack_ratio)
    console.log(guard_ratio)
    console.log(control_ratio)
    if(attack_ratio == '' || guard_ratio == '' || control_ratio == ''){
      elert('随机计谋比例填写不完整')
      $('#select2-card_bag_id_'+ele_id+'-container').text('请选择')
      $('#chosed_card_bag_div_'+ele_id).html('')
      return false
    }

    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/game_types/get_chosed_card_bag',
        data: {card_bag_id: sl_val, attack_ratio: attack_ratio, guard_ratio: guard_ratio, control_ratio: control_ratio},
        success: function(result){
          $('#chosed_card_bag_div_'+ele_id).html(result)
        },
        error: function(XMLHttpResponse){
          $('#select2-card_bag_id_'+ele_id+'-container').text('请选择')
          // $('#chosed_card_bag_div_'+ele_id).html('')
          elert('请注意保底张数，每一类保底张数相加不要超过该类可随机的最大数量！！！')
        }
      })
    }
  })

  $('body').on('change', '.card_bag_select_game_type', function(){
    var sl_val = $(this).val()
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/game_types/get_chosed_card_bag',
        data: {card_bag_id: sl_val},
        success: function(result){
          $('#chosed_card_bag_div').html(result)
        },
        error: function(XMLHttpResponse){
          alert('选择失败')
        }
      })
    }
  })

})


function calc_key_percent(ele_id){
  var p_num = parseInt($('#'+ele_id).val())
  var pct = (100/p_num).toFixed(2)
  console.log(pct)
  $('.key_percent').text(pct + '%')
}

// 启用、停用
function game_type_shelf(game_type_id, status){
  $('#shelfGameTypeModal').modal('show')
  $('#shelfGameTypeModal').on('shown.bs.modal',function(){
    // $('#shelf_game_type_name').html(game_type_name)
    $('#shelf_game_type_id').val(game_type_id)
    $('#shelf_game_type_status').val(status)
    var str = status == 1 ? '启用' : '停用'
    $('#shelf_status, #shelf_title').text(str)
  })
}

// 增加、减少库存
function stock_chnage(product_id, product_name, type){
  $('#stockChangeModal').modal('show')
  $('#stockChangeModal').on('shown.bs.modal', function(){
    $('#stock_change_product_id').val(product_id)
    $('#stock_change_product_name').text(product_name)
    $('#stock_change_type').val(type)
    var str = type == 1 ? '增加' : '减少'
    $('#stock_change_str').text(str)
  })
}

// 自建赛场规则 启用、停用
function self_game_rule_shelf(self_game_rule_id, status){
  $('#shelfSelfGameRuleModal').modal('show')
  $('#shelfSelfGameRuleModal').on('shown.bs.modal',function(){
    $('#shelf_self_game_rule_id').val(self_game_rule_id)
    $('#shelf_self_game_rule_status').val(status)
    var str = status == 1 ? '启用' : '停用'
    $('#shelf_status, #shelf_title').text(str)
  })
}

// 修改规则说明
function game_desc_change(game_type_id, game_type_name){
  $('#gameDescChangeModal').modal('show');
  var desc = ''
  $.ajax({
    type: 'get',
    url: '/game_types/get_game_type_name',
    data: {id: game_type_id},
    success: function(result){
      desc = result.data
    },
    error: function(XMLHttpResponse){
      alert('操作失败')
    }
  })
  $('#gameDescChangeModal').on('shown.bs.modal',function(){
    $('#change_game_type_name').val(game_type_name)
    $('#game_type_game_desc').val(desc)
    $('#change_game_type_id').val(game_type_id)
  })
}

function get_round_time(ele_id, game_rule_id, controller_name){
  var r_num = parseInt($('#'+ele_id).val())
  console.log(r_num)
  $.ajax({
    type: 'get',
    url: '/'+controller_name+'/round_time_form',
    data: {game_rule_id: game_rule_id, r_num: r_num},
    success: function(result){
      $('.round_time').html(result)
    },
    error: function(XMLHttpResponse){
      alert('网络异常')
    }
  })

  if(controller_name == 'self_game_rules'){
    $.ajax({
      type: 'get',
      url: '/'+controller_name+'/round_card_form',
      data: {game_rule_id: game_rule_id, r_num: r_num},
      success: function(result){
        $('.round_card').html(result)
      },
      error: function(XMLHttpResponse){
        alert('网络异常')
      }
    })
  }
}


$(document).on('turbolinks:load', function () {
  $('#game_type_submit,#self_game_rule_submit').on('click', function(){
    var round_num = $('#curr_round_num').val()
    var flag = true
    if(round_num > 0){
      for(var i = 0; i < round_num; i++){
        // console.log((1+i)+'轮')
        if(parseInt($('#attack_ratio_'+(i+1)).val())+parseInt($('#guard_ratio_'+(i+1)).val())+parseInt($('#control_ratio_'+(i+1)).val()) != parseInt($('#trick_max_'+(i+1)).val())){
          flag = false
          elert('第'+(i+1)+'轮随机计谋比例之和不等于计谋上限')
        }
      }
    }
    if(!flag){
      return false
    }

  })
})
