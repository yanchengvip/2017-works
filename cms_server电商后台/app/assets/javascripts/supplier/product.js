// g审核
function submit_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#submitSupplierProductModal').modal('show');
  $('#submitSupplierProductModal').on('shown.bs.modal',function(){
    $('#review_supplier_product_name').html(supplier_product_name)
    $('#review_supplier_product_id').val(supplier_product_id)
    $('#review_supplier_product_status').val(status)
  })
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


$(document).on('turbolinks:load', function () {

  $(".is_select2").select2()

  $('body').on('click', '.del_item_new', function(){
    $(this).parent().parent().remove()
  })

  $('img.list').on('error', function(){
    // $(this).attr('src', '../../no_pic.png')
    // $(this).css('max-width', '150px').css('max-height', '200px')
    // $(this).attr('onerror', null)
    $(this).css('display','none')
  })

  $('.category_select').on('change', function(){
    var sl_val = $(this).val()
    var ele_id = $(this).attr('id')
    var ops = "<option value=''>请选择</option>"
    // 分类
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/supplier/products/get_next_categories',
        data: {category_id: sl_val},
        success: function(result){
          if(result.status == 200){
            for(var i = 0; i < result.data.length; i++){
              // console.log(result.data[i][0] + '&' + result.data[i][1]);
              ops += "<option value=" + result.data[i][1] + '>' + result.data[i][0] + "</option>"
            }
            // console.log(ops)
            if(ele_id == 'supplier_product_category1_id'){
              $('#supplier_product_category2_id').html(ops)
              $('#supplier_product_category3_id').html('')
            }else if(ele_id == 'supplier_product_category2_id'){
              $('#supplier_product_category3_id').html(ops)
            }
          }else{
            // elert(result.msg)
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
        }
      })
    }
    // 属性
    ele = $(this)
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/supplier/products/get_attributes',
        data: {category_id: sl_val},
        success: function(result){
          $('#product_attribute_div').html(result)
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
        }
      })
    }
  })

  $('#supplier_product_submit').on('click', function(){

    console.log($('.sku_content').length)
    if($('.sku_content').length < 1){
      elert('没有填写sku')
      return false
    }
    var spsp = $('#supplier_product_spec_pic').val()
    console.log(spsp)
    if(spsp == ''){
      elert('没有上传尺寸说明图片')
      return false
    }
    var spmp = $('#supplier_product_major_pic').val()
    if(spmp == ''){
      elert('没有上传主图片')
      return false
    }

    var sprpi = $.trim($('#supplier_product_relate_product_ids').val())
    var spcn = $.trim($('#supplier_product_color_name').val())
    var spcp = $('#supplier_product_color_pic').val()
    if(!!sprpi){
      if(spcn == '' || spcp == ''){
        elert('颜色或颜色图片不能为空')
        return false
      }
    }

    var sbos = $(".select_box option")
    // console.log(sbos.length)
    var flag = false
    sbos.each(function(index, el) {
      if($(el).is(':selected')){
        // alert($(el).val())
        flag = true
      }
    });
    if(!flag){
      elert('没有选择属性')
      return false
    }



  })





})


// $(function(){
$(document).on('turbolinks:load', function () {
  $('#add_multiple_images').on('click', function(){
    $('#begin_up').click()
  })
  $('#begin_up').on('click', function(){
    $(this).fileupload({
      dataType: 'json',
      url: '/supplier/images/upload',
      accept: 'application/json',
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
      sequentialUploads: true,
      //maxFileSize: 5000000, //5mb
      add: function (e, data) {
        var acceptFileTypes = /(\.|\/)(gif|jpe?g|png)$/i;
        if(data.originalFiles[0]['type'].length <= 0){
          elert('图片格式不正确！只能上传jpg,png等图片')
          return false
        }
        if (data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
          elert('图片格式不正确！只能上传jpg,png等图片')
          return false
        }
        data.submit();
      },
      complete: function (result, textStatus, jqXHR) {
        var data = JSON.parse(result.responseText)
        $.ajax({
          type: 'get',
          url: '/supplier/products/image_form',
          data: {imageurl: data.img_url},
          success: function(result){
            $('#product_images_body').append(result)
            $('.sequence_td').each(function(index, el) {
              $(el).val(index + 1)
            });
          },
          error: function(XMLHttpResponse){
            elert('选择失败')
          }
        })

      }

    });
    $(this).bind('fileuploadsubmit', function (e, data) {
      data.formData = { model_name: "ProductImage" };
    });

  })
})

