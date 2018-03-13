// 上下架
function shelf_auction_product(auction_product_id, auction_product_name, status){
  $('#shelfAuctionProductModal').modal('show');
  $('#shelfAuctionProductModal').on('shown.bs.modal',function(){
    $('#shelf_auction_product_name').html(auction_product_name)
    $('#shelf_auction_product_id').val(auction_product_id)
    $('#shelf_auction_product_status').val(status)
    var str = status == 0 ? '下架' : '上架'
    $('#shelf_status_txt').text(str)
  })
}

// 审核
function review_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#reviewSupplierProductModal').modal('show');
  $('#reviewSupplierProductModal').on('shown.bs.modal',function(){
    $('#review_supplier_product_name').html(supplier_product_name)
    $('#review_supplier_product_id').val(supplier_product_id)
    $('#review_supplier_product_status').val(status)
  })
}


function ms_review_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#msReviewSupplierProductModal').modal('show');
  $('#msReviewSupplierProductModal').on('shown.bs.modal',function(){
    $('#review_supplier_product_name').html(supplier_product_name)
    $('#review_supplier_product_id').val(supplier_product_id)
    $('#review_supplier_product_status').val(status)
    if(status == 0){
      $('#ms_review_status').text('驳回')
      $('#ms_next_review_man').text('供应商')
    }else{
      $('#ms_review_status').text('审核通过')
      $('#ms_next_review_man').text('总监')
    }
  })
}

function zj_review_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#zjReviewSupplierProductModal').modal('show');
  $('#zjReviewSupplierProductModal').on('shown.bs.modal',function(){
    $('#zj_review_supplier_product_name').html(supplier_product_name)
    $('#zj_review_supplier_product_id').val(supplier_product_id)
    $('#zj_review_supplier_product_status').val(status)
    if(status == 0){
      $('#zj_review_status').text('驳回')
      $('#zj_next_review_man').text('供应商')
    }else{
      $('#zj_review_status').text('审核通过')
      $('#zj_next_review_man').text('财务')
    }
  })
}

function cw_review_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#cwReviewSupplierProductModal').modal('show');
  $('#cwReviewSupplierProductModal').on('shown.bs.modal',function(){
    $('#cw_review_supplier_product_name').html(supplier_product_name)
    $('#cw_review_supplier_product_id').val(supplier_product_id)
    $('#cw_review_supplier_product_status').val(status)
    if(status == 0){
      $('#cw_review_status').text('驳回')
      $('#cw_next_review_man').text('供应商')
    }else{
      $('#cw_review_status').text('审核通过')
      $('#cw_next_review_man').text('编辑')
    }
  })
}

function bj_review_supplier_product(supplier_product_id, supplier_product_name, status){
  $('#bjReviewSupplierProductModal').modal('show');
  $('#bjReviewSupplierProductModal').on('shown.bs.modal',function(){
    $('#bj_review_supplier_product_name').html(supplier_product_name)
    $('#bj_review_supplier_product_id').val(supplier_product_id)
    $('#bj_review_supplier_product_status').val(status)
    if(status == 0){
      $('#bj_review_status').text('驳回')
      $('#bj_next_review_man').text('供应商')
    }else{
      $('#bj_review_status').text('审核通过')
      $('#bj_next_review_man').text('上架')
    }
  })
}

function change_discount_auction_product(auction_product_id, auction_product_name){
  var discount = $('#discount_' + auction_product_id).text()
  $('#changeDiscountAuctionProductModal').modal('show');
  $('#changeDiscountAuctionProductModal').on('shown.bs.modal',function(){
    $('#change_auction_product_name').text(auction_product_name)
    $('#change_auction_product_id').text(auction_product_id)
    $('#change_auction_product_discount').val(discount)
  })
}
//全选
function choose_all_product(){
  console.log(11)
  $("#choose_unall").prop("checked",false)
  $("[name='prducts_shelf[]']").prop("checked",true)
}

//反选
function choose_unall_product(){
  $("#choose_all").prop("checked",false)
  $("[name='prducts_shelf[]']").prop("checked",false)
}

$(document).on('turbolinks:load', function () {

  $('.category_select').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    var ele_id = $(this).attr('id')
    var ops = "<option value=''>请选择</option>"
    // 分类
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/auction/products/get_next_categories',
        data: {category_id: sl_val},
        success: function(result){
          if(result.status == 200){
            for(var i = 0; i < result.data.length; i++){
              // console.log(result.data[i][0] + '&' + result.data[i][1]);
              ops += "<option value=" + result.data[i][1] + '>' + result.data[i][0] + "</option>"
            }
            // console.log(ops)
          }else{
            elert(result.msg)
          }
          console.log(ele_id)
          if(ele_id == 'auction_product_category1_id'){
            $('#auction_product_category2_id').html(ops)
            $('#auction_product_category3_id').html('')
          }else if(ele_id == 'auction_product_category2_id'){
            $('#auction_product_category3_id').html(ops)
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
        }
      })
    }
    // 属性

    console.log(!!sl_val)
    console.log(!ele.hasClass('theme'))
    if(!!sl_val && !ele.hasClass('theme')){
      $.ajax({
        type: 'get',
        url: '/auction/products/get_attributes',
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


  $('.editor_category_select').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    var ele_id = $(this).attr('id')
    var ops = "<option value=''>请选择</option>"
    // 分类
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/auction/products/get_next_categories',
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
            elert(result.msg)
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
        }
      })
    }
    // 属性
    if(!!sl_val && !ele.hasClass('theme')){
      $.ajax({
        type: 'get',
        url: '/auction/products/get_attributes',
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

  $('#provider_submit').on('click', function(){
    var email = $('#manage_provider_login').val()
    var myreg = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
    if(!myreg.test(email))
    {
      elert('请输入正确邮箱！');
      return false;
    }
  })

  $('#auction_product_submit').on('click', function(){
    var appp = $('#auction_product_provider_price').val()
    if(appp == ''){
      elert('销售底价/供货价不能为空')
      return false
    }
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

    var sprpi = $.trim($('#auction_product_relate_product_ids').val())
    var spcn = $.trim($('#auction_product_color_name').val())
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

  $(function(){
    $('#add_multiple_images').on('click', function(){
      $('#begin_up').click()
    })
    $('#begin_up').on('click', function(){
      $(this).fileupload({
        dataType: 'json',
        url: '/images/upload',
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
            url: '/auction/products/image_form',
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


})


function batch_shelf(status){
  var ids = ''
  $('.pshelf').each(function(index, el) {
    if($(el).is(':checked')){
      ids += (',' + $(this).attr('id'))
    }
  });
  console.log(ids)
  if(!!ids){
    $.ajax({
      type: 'post',
      url: '/auction/products/batch_shelf',
      data: {pids: ids, shelf_status: status},
      success: function(result){
        window.location.reload()
      },
      error: function(XMLHttpResponse){
        elert('操作失败')
      }
    })
  }else{
    // alert(2)
  }
}

function batch_ms_review(status){
  var ids = ''
  $('.pms_review').each(function(index, el) {
    if($(el).is(':checked')){
      ids += (',' + $(this).attr('id'))
    }
  });
  console.log(ids)
  if(!!ids){
    $.ajax({
      type: 'post',
      url: '/auction/products/batch_ms_review',
      data: {pids: ids, review_status: status},
      success: function(result){
        window.location.reload()
      },
      error: function(XMLHttpResponse){
        elert('操作失败')
      }
    })
  }else{
    // alert(2)
  }
}

function batch_zj_review(status){
  var ids = ''
  $('.pzj_review').each(function(index, el) {
    if($(el).is(':checked')){
      ids += (',' + $(this).attr('id'))
    }
  });
  console.log(ids)
  if(!!ids){
    $.ajax({
      type: 'post',
      url: '/auction/products/batch_zj_review',
      data: {pids: ids, review_status: status},
      success: function(result){
        window.location.reload()
      },
      error: function(XMLHttpResponse){
        elert('操作失败')
      }
    })
  }else{
    // alert(2)
  }
}

function batch_cw_review(status){
  var ids = ''
  $('.pcw_review').each(function(index, el) {
    if($(el).is(':checked')){
      ids += (',' + $(this).attr('id'))
    }
  });
  console.log(ids)
  if(!!ids){
    $.ajax({
      type: 'post',
      url: '/auction/products/batch_cw_review',
      data: {pids: ids, review_status: status},
      success: function(result){
        window.location.reload()
      },
      error: function(XMLHttpResponse){
        elert('操作失败')
      }
    })
  }else{
  }
}

function batch_edit(){
  var ids = ''
  $('.pshelf').each(function(index, el) {
    if($(el).is(':checked')){
      ids += (',' + $(this).attr('id'))
    }
  });
  console.log(ids)
  if(!!ids){
    $('#choseChangeItemModal').modal('show')
    $('#choseChangeItemModal').on('shown.bs.modal',function(){
      $('#chosed_product_ids').val(ids)
    })
  }else{
  }
}

$(document).on('turbolinks:load', function () {

  $('.category_search').on('change', function(){
    var sl_val = $(this).val()
    ele = $(this)
    var ele_id = $(this).attr('id')
    var ops = "<option value=''>请选择</option>"
    // 分类
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: '/auction/products/get_next_categories',
        data: {category_id: sl_val},
        success: function(result){
          if(result.status == 200){
            for(var i = 0; i < result.data.length; i++){
              // console.log(result.data[i][0] + '&' + result.data[i][1]);
              ops += "<option value=" + result.data[i][1] + '>' + result.data[i][0] + "</option>"
            }
          }
          console.log(ele_id)
          if(ele_id == 'category1_id'){
            $('#category2_id').html(ops)
            $('#category3_id').html('')
            $('#category2_span').removeClass('hide')
          }else if(ele_id == 'category2_id'){
            $('#category3_id').html(ops)
            $('#category3_span').removeClass('hide')
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
        }
      })
    }
    // 属性
    console.log(!!sl_val)
  })
})
