$(document).on('turbolinks:load', function () {
  $(".package_select2").select2();
  $('body').on('click', '.popover', function(){
    $(this).popover('hide')
  })

  // 上架时间购买记录
  $('#q_created_at_gteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('#q_created_at_gteq').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  // 上架时间购买记录
  $('#q_created_at_lteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('#q_created_at_lteq').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  // 上架时间礼包
  $('#q_onshelf_time_gteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('#q_onshelf_time_gteq').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('#q_published_time_gteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('#q_published_time_gteq').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('.search_time_begin').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.search_time_begin').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('.search_time_end').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.search_time_end').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('.game_begin').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.game_begin').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('.game_end').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.game_end').val(moment(ev.date).format('YYYY-MM-DD HH:mm'))
  });
  $('.es_time_begin').datetimepicker({
      format: 'YYYY-MM-DD',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.es_time_begin').val(moment(ev.date).format('YYYY-MM-DD'))
  });
  $('.es_time_end').datetimepicker({
      format: 'YYYY-MM-DD',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.es_time_end').val(moment(ev.date).format('YYYY-MM-DD'))
  });
  $('.game_time_begin').datetimepicker({
      format: 'HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.game_time_begin').val(moment(ev.date).format('HH:mm'))
  });
  $('.game_time_end').datetimepicker({
      format: 'HH:mm',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.game_time_end').val(moment(ev.date).format('HH:mm'))
  });
})

// 删除礼包
function package_delete(package_id,package_name){
  $('#deletePackagetModal').modal('show');
  $('#deletePackagetModal').on('shown.bs.modal',function(){
    $('#del_package_name').html(package_name)
    $('#del_package_id').val(package_id)
  })
}
// 礼包上下架
function package_shelf(package_id, package_name, status){

  $('#shelfPackagetModal').modal('show');
  $('#shelfPackagetModal').on('shown.bs.modal',function(){
    $('#shelf_package_name').html(package_name)
    $('#shelf_package_id').val(package_id)
    $('#shelf_package_status').val(status)

    if(status == 1){
      $('#shelf_status').text('上架')
      $('#shelf_title').text('上架')
    }else{
      $('#shelf_status').text('下架')
      $('#shelf_title').text('下架')
    }
  })
}

//限制输入框的字数
function validate_length_of_words(objid, max_num) {
  //添加时，验证名称的长度
  var current_num = $('#'+objid).val().length

  if (current_num <= max_num) {
    $('#'+objid).next().first('.left_str_num').html('还能输入' + (max_num - current_num) + '字')
  } else {
    var text_num = $('#'+objid).val().substr(0, max_num)
    $('#'+objid).val(text_num)
    $('#'+objid).next().first('.left_str_num').html('还能输入0字')
  }

}

function del_bad_val(objid){
  $('#'+objid).val('')
}

// 弹框
function elert(msg){
  $('#ErroralertModal').modal('show')
  $('#ErroralertModal').on('shown.bs.modal',function(){
      $('.error-content').html(msg)
  }).on('hidden.bs.modal', function (e) {
      $('.error-content').html('')
  })
}



$(function(){
  // icon
  $('#add_package_icon').fileupload({
    dataType: 'json',
    url: '/images/upload',
    accept: 'application/json',
    sequentialUploads: true,
    add: function(e, data){
      if(data.originalFiles[0]['size'] > 100000){
          alert('图片最大为100k')
      }else{
          data.submit();
      }
    },
    complete: function(result, textStatus, jqXHR){
      var data = JSON.parse(result.responseText);
      $("#package_icon_url").val(data.img_path);
      $("#preview_package_icon_url").attr('src', data.img_url);
      $('#package_icon_url_link').removeClass('hide');
    }
  })

  // 展示图
  $('#add_package_image').fileupload({
    dataType: 'json',
    url:'/images/upload',
    accept: 'application/json',
    sequentialUploads: true,
    //maxFileSize: 5000000, //5mb
    add: function(e,data){
      if(data.originalFiles[0]['size'] > 100000){
        alert('图片最大为100k')
      }else{
        data.submit();
      }
    },
    complete: function(result, textStatus, jqXHR){
        var pro_image_urls = $('#pro_image_urls').val()
        var data = JSON.parse(result.responseText)

        if (pro_image_urls.split(',').length > 4){
            alert('展示图最多5张')
            return
        }
        // $('#preview_package_imgs').append($('.close_img').clone())
        var img = $("<img width='23%' height='23%' class='img_show' style='margin-right: 20px;'>").attr('src',data.img_url)
        $('#preview_package_imgs').append(img)
        $('.origin').clone().removeClass('origin').attr('data_url', data.img_url).appendTo('#preview_package_imgs');
        if (pro_image_urls == ""){
            $('#pro_image_urls').val(data.img_path)
        }else{
            img_url = pro_image_urls + "," +  data.img_path
            $('#pro_image_urls').val(img_url)
        }

    }

  });



  //鼠标划过事件
  $("#preview_package_imgs").on('click', '.img_show', function(){
    if($(this).attr('src') == $(this).next().first("img").attr('data_url')){
      $(this).next().first("img").removeClass('hide');
    }
  })

  $("#preview_package_imgs").on('click', '.close_img', function(){
    var this_data_url = $(this).attr('data_url')
    var pro_image_urls = $('#pro_image_urls').val().split(',')
    // console.log($(this).prev('.img_show'))
    $(this).prev('.img_show').first().remove()
    $(this).remove()

    pro_image_urls.splice($.inArray(this_data_url, pro_image_urls),1);
    $('#pro_image_urls').val(pro_image_urls.join(','))
  })


  $('.closeimg').on('click', function(){
    // console.log($(this).next().first("img").attr('id'));
    if($(this).next().first("img").attr('id') != 'img_btn'){
      $(this).next().first("img").remove();
    }
  })

  $('#package_icon_btn').on('click', function(){
    $('#add_package_icon').trigger('click');

  })

  $('#package_img_btn').on('click', function(){
    $('#add_package_image').trigger('click');

  })

  // $('body').on('click', '.del_item_new', function(){
  //   console.log($(this).parent('tr'))
  //   $(this).parent().parent().remove()
  // })

})

$(document).on('turbolinks:load', function () {
  // 礼包内容选择卡牌
  $('body').on('change', '.card_chose', function(){
    var sl_val = $(this).val()
    ele = $(this)
    $.ajax({
      type: 'get',
      url: '/cards/' + sl_val + '/get_card',
      data: {},
      success: function(result){
        if(result.status == 200){
          console.log(ele.parent().parent().next('.card_price').children('span'))
          $(ele.parent().parent().next('.card_price').children('span')[0]).text(result.data.price)
          $(ele.parent().parent().next('.card_price').children('input')[0]).val(result.data.price)
        }
      },
      error: function(XMLHttpResponse){
        alert('选择失败')
      }
    })
  })

  $('body').on('click', '.del_item_new', function(){
    // console.log($(this).parent('tr'))
    $(this).parent().parent().remove()
  })

  $('#package_submit').on('click', function(){
    // 售卖渠道
    var sale_channels_ok = false
    $('.sale_channels_check').each(function(index, el) {
      if($(el).is(':checked')){
        sale_channels_ok = true
      }
    });
    if(!sale_channels_ok){
      $('#sale_channels_tip').popover('show')
      return false
    }else{
      $('#sale_channels_tip').popover('hide')
    }
    // 礼包分类
    var package_type_id_ok = false
    $('.package_type_id_radio').each(function(index, el) {
      if($(el).is(':checked')){
        package_type_id_ok = true
      }
    });
    if(!package_type_id_ok){
      $('#package_type_id_tip').popover('show')
      return false
    }else{
      $('#package_type_id_tip').popover('hide')
    }

    // 上下架时间
    var now = new Date()
    var shelf_time_now = $("#shelf_time_now").is(':checked')
    var shelf_time_later = $("#shelf_time_later").is(':checked')
    var package_onshelf_time = getDate($('#package_onshelf_time').val())
    var package_offshelf_time = getDate($('#package_offshelf_time').val())
    if(shelf_time_now && package_offshelf_time <= now){
      $('#package_offshelf_time_tip').popover('show')
      return false
    }
    if(shelf_time_later && $('#package_onshelf_time').val() == ''){
      console.log($('#package_onshelf_time').val())
      $('#package_onshelf_time_tip').popover('show')
    }
    if(shelf_time_later && package_offshelf_time <= package_onshelf_time){
      $('#package_offshelf_time_tip').popover('show')
      return false
    }
    return false
    // 价格
    var package_price = $('#package_price').val()
    if(package_price <= 0){
      $('#package_price_tip').popover('show')
      return false
    }else{
      $('#package_price_tip').popover('hide')
    }
    // 简介
    var package_summary = $('#package_summary').val()
    if(package_summary.trim() == ''){
      $('#package_summary_tip').popover('show')
      return false
    }else{
      $('#package_summary_tip').popover('hide')
    }

  })

  $('.channel_label').on('click', function(){
    channel_val = $(this).children().val()
    console.log(channel_val)
    if(channel_val == 3){
      $('.not_for_battle').hide()
      $('.prize_radio').each(function(index, el) {
        $(el).attr('checked', false)
      });
      $('#random_item').hide()
    }else{
      $('#random_item').show()
      $('.not_for_battle').show()
    }
    $.ajax({
      type: 'get',
      url: '/packages/get_package_type',
      data: {sale_channel: channel_val},
      success: function(result){
        $('#channel_package_type').html(result)
      },
      error: function(XMLHttpResponse){
        alert('选择失败')
      }
    })
  })

  // 等值
  $('.add_scheme_package').on('click', function(){
    var package_id = $(this).attr('id').split('_')[0]
    var random_id = $('#random_num').val()
    $('#random_num').val($('#random_num').val() + 1)
    var tab_id = 'tab' + random_id
    var tab_count_0 = $('.scheme_count').last().text() || 0
    var tab_count_1 = parseInt(tab_count_0) + 1
    // console.log($('.scheme_count').last().text())
    $('#sheme_nav_tabs li[class="active"]').removeClass('active')
    var nav_tab = $('<li role="presentation" class="active"><a href='+"#"+tab_id+' aria-controls="'+tab_id+'" role="tab" data-toggle="tab">方案<span class="scheme_count">'+tab_count_1+'</span></a></li>')
    $('#sheme_nav_tabs').append(nav_tab)

    $.ajax({
      type: 'get',
      url: '/packages/'+package_id+'/scheme_form',
      data: {tab_id: tab_id},
      success: function(result){
        $('#scheme_tab_panes div[role="tabpanel"]').each(function(index, el) {
          if($(el).hasClass('active')){
            $(el).removeClass('active')
          }
        });
        $('#scheme_tab_panes').append(result)
      },
      error: function(XMLHttpResponse){
        alert('添加失败，请重试')
      }
    })
  })

  $('.game_luck_delete').on('click', function(){
    var ele_id = $(this).attr('id').split('_')[1]
    $.ajax({
      type: 'delete',
      url: '/game_luckies/'+ele_id,
      data: {},
      success: function(result){
        window.location.reload()
      },
      error: function(XMLHttpResponse){
        alert('删除失败，请重试')
      }
    })
  })

  // 选择
  $('body').on('click', '.item_scheme_card_check', function(){
    var tab_id = $(this).attr('id').split('_')[2]
    var card_id = $(this).attr('id').split('_')[0]
    if(!$(this).is(':checked')){
      $('#'+card_id+'_count_'+tab_id).val('')
    }else{
      $('#alert_'+tab_id).addClass('hide')
    }
    cal_val(tab_id)
  })
  // 修改张数
  $('body').on('keyup', '.card_count', function(){
    var tab_id = $(this).attr('id').split('_')[2]
    var card_id = $(this).attr('id').split('_')[0]
    if(!$('#'+card_id+'_checkbox_'+tab_id).is(':checked')){
      $(this).val('')
      $('#alert_'+tab_id).removeClass('hide')
      return false
    }else{
      $('#alert_'+tab_id).addClass('hide')
    }
    cal_val(tab_id)
  })

  $('#game_product_tag_id').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    console.log(sl_val)
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: "/game_leagues/get_prize",
        data: {game_product_tag_id: sl_val},
        success: function(result){
          $('#game_league_battle_product_id').html(result)
        },
        error: function(XMLHttpResponse){
          elert('网络错误')
        }
      })
    }
  })


})

function cal_val(tab_id){
  var total_price = 0
  $('.tr_'+tab_id).each(function(index, el) {
    var card_id = $(el).children().find('.item_scheme_card_check').attr('id').split('_')[0]
    console.log(card_id)
    if($(el).children().find('.item_scheme_card_check').is(':checked')){
      var price = parseFloat($('#'+card_id+'_card_price_'+tab_id).text() || 0)
      var count = parseInt($('#'+card_id+'_count_'+tab_id).val() || 0)
      console.log(price)
      console.log(count)
      total_price += (price * count)
    }
  });
  $('#price_total_'+tab_id).text(total_price)
  $('#new_item_price_'+tab_id).val(total_price)
}

// 方案删除
function del_scheme_confirm(item_id){
  $('#delSchemeModal').modal('show')
  $('#delSchemeModal').on('shown.bs.modal',function(){
    $('#del_item_id').val(item_id)
  })
}

function order_export_submit(submit_type) {
  if (submit_type === "export") {
    $("#search_form").attr("action", "/battle_products/orders.csv");
  }
  $("#search_form").submit();
  $("#search_form").attr("action", "/battle_products/orders");
  $("#order_search_submit").removeAttr('data-disable-with')
  $("#order_search_submit").attr('disabled',false)
}
