$(function(){
  $('#reset_form').on('click', function(){
    $('#search_form')[0].reset()
  })

  $('#add_card_submit').on('click', function(){
    // var card_price = $('#card_price').val()
    // if(card_price <= 0){
    //   $('#card_price_tip').popover('show')
    //   return false
    // }
    // 简介
    var card_summary = $('#card_summary').val()
    if(card_summary.trim() == ''){
      $('#card_summary_tip').popover('show')
      return false
    }else{
      $('#card_summary_tip').popover('hide')
    }
    // 缩略图
    var thumbnail = $('#preview_thumbnail').attr('src')
    if(thumbnail == ''){
      $('#card_thumbnail_tip').popover('show')
      return false
    }else{
      $('#card_thumbnail_tip').popover('hide')
    }

  })

})


// 管理员
function admin_delete(admin_id, admin_name){
  $('#deleteAdminModal').modal('show');
  $('#deleteAdminModal').on('shown.bs.modal',function(){
    $('#del_admin_name').html(admin_name)
    $('#del_admin_id').val(admin_id)
  })
}

$(document).on('turbolinks:load', function () {
// $(function(){
  $('#admin_submit').on('click', function(){
    var reg_num=/^\+?[1-9][0-9]*$/;
    var reg_err =/[`~!@#$%^&*_+<>{}\/'[\]]/im;
    var name = $('#nickname').val()
    if(reg_num.test(name) || reg_err.test(name)){
      $('#nickname_tip').popover('show')
      return false
    }
    var email = $('#email').val()
    // if(!email.match(/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/)){
    if(email.indexOf('@') <= 0){
      $('#email_tip').popover('show')
      return false
    }
  })
})

// 版本删除
function app_version_delete(app_version_id, app_name, version){
  $('#deleteAppVersionModal').modal('show');
  $('#deleteAppVersionModal').on('shown.bs.modal',function(){
    $('#del_app_name').html(app_name)
    $('#del_version').html(version)
    $('#del_app_version_id').val(app_version_id)
  })
}

// 重置
function reset_pwd(admin_id, name){
  $('#resetPwdModal').modal('show');
  $('#resetPwdModal').on('shown.bs.modal',function(){
    $('#admin_name').html(name)
    $('#reset_admin_id').val(admin_id)
  })
}

// 文案删除
function copy_delete(copy_id, copy_title){
  $('#deleteCopyModal').modal('show');
  $('#deleteCopyModal').on('shown.bs.modal',function(){
    $('#del_copy_title').html(copy_title)
    $('#del_copy_id').val(copy_id)
  })
}

$(document).on('turbolinks:load', function () {
  $('#card_order_num').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    $.ajax({
      type: 'get',
      url: '/cards/get_order_num',
      data: {num: sl_val},
      success: function(result){
        if(result.status == 500){
          console.log(ele.val())
          s = $('#card_order_num').get(0)
          s.options[0].selected = true
          // $('#card_order_num').val('')
          $('#select2-card_order_num-container').text('请选择')
          elert(result.msg)
        }
      },
      error: function(XMLHttpResponse){
        alert('选择失败')
      }
    })
  })

  $('#see_orders').on('click', function(){
    if($('#card_orders_div').hasClass('hide')){
      $('#card_orders_div').removeClass('hide')
    }else{
      $('#card_orders_div').slideToggle('fast')
    }
    if($.trim($('#card_orders_div').text())== ''){
      $('#card_orders_text').addClass('red').text('还没有设置排序')
    }
  })
})

function check_words(itemId) {
  value = $('#'+itemId).val()
  console.log(value)
  value = value.replace(/[&\|\\\*^%$#，.;/<>@+\-]/g,"")
  $('#'+itemId).val(value)
}

$(document).on('turbolinks:load', function () {
  $('#card_user_owns_submit').on('click', function(){
    value = $('#user_mobiles').val()
    size = value.split(',').length
    if(size > 20){
      elert('手机号一次不能输入超过20个')
      return false
    }
  })

  $('.headimg').on('click', function(){
    var img = $(this).attr('data_img')
    $('#showHeadimgModal').modal('show')
    $('#showHeadimgModal').on('shown.bs.modal',function(){
      $('#big_headimg').attr('src', img)
    })

  })
})
