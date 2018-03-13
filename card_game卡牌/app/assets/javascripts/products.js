$(document).on('turbolinks:load', function () {
    $(".select2-picker").select2();
})


function battle_product_delete(obj_id, obj_name) {

    $('#deleteBattleProductModal').modal('show');
    $('#deleteBattleProductModal').on('shown.bs.modal', function () {
        $('#del_battle_product_name').html(obj_name)
        $('#del_battle_product_id').val(obj_id)
    })

}

//限制输入框的字数

function validate_words_length(max_num,input_id, div_id) {
    //验证输入框的长度
    var current_num = $('#' + input_id).val().length
    if (current_num <= max_num) {
        $('#' + div_id).html('还能输入' + (max_num - current_num) + '字')
    } else {
        var text_num = $('#' + input_id).val().substr(0, max_num)
        $('#' + input_id).val(text_num)
        $('#' + div_id).html('还能输入0字')
    }


}


function validate_search_form(form) {
    begin = form.elements["inventory_count_begin"].value;
    end = form.elements["inventory_count_end"].value;
    if (begin != '' && end != '') {
        if (parseInt(begin) > parseInt(end)) {
            alertTX('库存只能输入1-10这种由小到大的数字')
            return false
        }

    }
}

// 上下架
function game_product_tag_able(game_product_tag_id, game_product_tag_name, status){
  $('#gameProductTagAbleModal').modal('show');
  $('#gameProductTagAbleModal').on('shown.bs.modal',function(){
    $('#able_game_product_tag_name').html(game_product_tag_name)
    $('#able_game_product_tag_id').val(game_product_tag_id)
    $('#able_game_product_tag_status').val(status)

    var str = status == 0 ? '停用' : '启用'
    $('#able_status, #able_title').text(str)
  })
}

// 上下架
function mall_product_tag_able(mall_product_tag_id, mall_product_tag_name, status){
  $('#mallProductTagAbleModal').modal('show');
  $('#mallProductTagAbleModal').on('shown.bs.modal',function(){
    $('#able_mall_product_tag_name').html(mall_product_tag_name)
    $('#able_mall_product_tag_id').val(mall_product_tag_id)
    $('#able_mall_product_tag_status').val(status)

    var str = status == 0 ? '停用' : '启用'
    $('#able_status, #able_title').text(str)
  })
}

$(document).on('turbolinks:load', function () {
    $(".battle_product_shelf").on('click', function(){
      var product_id = $(this).attr('data_id')

      $('#battleProductShelfModal').modal('show');
      $('#battleProductShelfModal').on('shown.bs.modal',function(){
          $.ajax({
            type: "get",
            url: '/battle_products/'+product_id+'/shelf_form',
            data: { },
            success: function(result){
              $('#battle_product_shelf_body').html(result)
            },
            error: function(XMLHttpResponse){
              $('#battleProductShelfModal').modal('hide')
              elert('操作失败')
            }
          })
      })

    });

    $(".game_product_shelf").on('click', function(){
      var product_id = $(this).attr('data_id')
      $('#gameProductShelfModal').modal('show');
      $('#gameProductShelfModal').on('shown.bs.modal',function(){
        $('#shelf_game_product_id').val(product_id)
      })
    });

    $(".self_game_product_shelf").on('click', function(){
      var product_id = $(this).attr('data_id')
      $('#selfGameProductShelfModal').modal('show');
      $('#selfGameProductShelfModal').on('shown.bs.modal',function(){
        $('#shelf_game_product_id').val(product_id)
      })
    });

    $(".mall_product_shelf").on('click', function(){
      var product_id = $(this).attr('data_id')
      $('#mallProductShelfModal').modal('show');
      $('#mallProductShelfModal').on('shown.bs.modal',function(){
        $('#shelf_mall_product_id').val(product_id)
      })
    });

    $(".mall_product_sort").on('click', function(){
      var product_id = $(this).attr('data_id')
      $('#mallProductResortModal').modal('show');
      $('#mallProductResortModal').on('shown.bs.modal',function(){
        $('#resort_mall_product_id').val(product_id)
      })
    });

})




