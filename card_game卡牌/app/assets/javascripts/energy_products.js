$(document).on('turbolinks:load', function () {
  $('#energy_product_order_num').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    $.ajax({
      type: 'get',
      url: '/energy_products/get_order_num',
      data: {num: sl_val},
      success: function(result){
        if(result.status == 500){
          console.log(ele.val())
          s = $('#energy_product_order_num').get(0)
          s.options[0].selected = true
          // $('#energy_product_order_num').val('')
          $('#select2-energy_product_order_num-container').text('请选择')
          elert(result.msg)
        }
      },
      error: function(XMLHttpResponse){
        alert('选择失败')
      }
    })
  })

  $('#see_energy_orders').on('click', function(){
    if($('#energy_product_orders_div').hasClass('hide')){
      $('#energy_product_orders_div').removeClass('hide')
    }else{
      $('#energy_product_orders_div').slideToggle('fast')
    }
    if($.trim($('#energy_product_orders_div').text())== ''){
      $('#energy_product_text').addClass('red').text('还没有设置排序')
    }
  })

  $('#energy_products_submit').on('click', function(){
    var arr = new Array()
    var res = true
    $('.buy_times').each(function(index, el) {
      if($(el).val() != '' && ($.inArray($(el).val(), arr) != -1)){
        res = false
        return
      }else{
        arr.push($(el).val())
      }
    });
    if(!res){ elert('次数不能重复！')}
    return res
  })
})


// 上下架
function energy_product_shelf(energy_product_id, energy_product_name, status){
  $('#shelfEnergyProductModal').modal('show');
  $('#shelfEnergyProductModal').on('shown.bs.modal',function(){
    $('#shelf_energy_product_name').html(energy_product_name)
    $('#shelf_energy_product_id').val(energy_product_id)
    $('#shelf_energy_product_status').val(status)

    if(status == 1){
      $('#shelf_status').text('上架')
      $('#shelf_title').text('上架')
    }else{
      $('#shelf_status').text('下架')
      $('#shelf_title').text('下架')
    }
  })
}

// 删除商品
function energy_product_delete(energy_product_id,energy_product_name){
  $('#deleteEnergyProducttModal').modal('show');
  $('#deleteEnergyProducttModal').on('shown.bs.modal',function(){
    $('#del_energy_product_name').html(energy_product_name)
    $('#del_energy_product_id').val(energy_product_id)
  })
}
