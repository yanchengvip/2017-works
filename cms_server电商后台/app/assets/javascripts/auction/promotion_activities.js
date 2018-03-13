$(document).on('turbolinks:load', function () {
  $('#supplier').hide()
  $('#price').hide()
  $('#pre_price').hide()
  $('#category').hide()
  $('#multiple').hide()
  $("#sel_menu2").select2({
    tags: true,
    width: "100%"
    // maximumSelectionLength: 3 //最多能够选择的个数
  });
  $("#category2").select2({
    tags: true,
    width: "100%"
    // maximumSelectionLength: 3 //最多能够选择的个数
  });
  $("input[name='auction_promotion_activity[discount_type]']").click(function() {
    var discount_type = $("input[name='auction_promotion_activity[discount_type]']:checked").val()
    if(discount_type == "1"){
      $('#multiple').show()
      $('#price').hide()
      $('#pre_price').hide()
    }else if (discount_type == "2") {
      $('#multiple').hide()
      $('#price').hide()
      $('#pre_price').show()
    }else if (discount_type == "3") {
      $('#multiple').hide()
      $('#price').show()
      $('#pre_price').hide()
    }
  });

  $("input[name='auction_promotion_activity[appoint_supplier]']").click(function() {
    var supplier_type = $("input[name='auction_promotion_activity[appoint_supplier]']:checked").val()
    if(supplier_type == "1"){
      $('#supplier').hide()
    }else if (supplier_type == "2") {
      $('#supplier').show()
    }
  });

  $("input[name='auction_promotion_activity[appoint_category]']").click(function() {
    var category_type = $("input[name='auction_promotion_activity[appoint_category]']:checked").val()
    if(category_type == "1"){
      $('#category').hide()
    }else if (category_type == "2") {
      $('#category').show()
    }
  });

  $('#auction_promotion_activity_submit').on('click', function(){
    var end_time = $("input[name='auction_promotion_activity[declar_end]']").val()

    var promotion_begin = $("input[name='auction_promotion_activity[promotion_begin]']").val()  //活动开始时间
    var promotion_end = $("input[name='auction_promotion_activity[promotion_end]']").val() //活动结束时间

    var begin = new Date(promotion_begin)
    var end = new Date(promotion_end)
    if(end <= begin ){
      elert('活动结束时间要大于活动开始时间')
      return false
    }

    var discount_type = $("input[name='auction_promotion_activity[discount_type]']:checked").val()
    var multiple_sales_count = $("input[name='auction_promotion_activity[multiple_sales_count]']").val()
    if(discount_type == "1"){
      if(multiple_sales_count < 1 || $("input[name='auction_promotion_activity[multiple_sales_discount]']").val() < 0.01){
          elert('连拍件数不能小于1,折扣不能小于0.01')
          return false
      }
    }else if (discount_type == "2") {
      if($("input[name='auction_promotion_activity[pre_price_more]']").val() < 0.01 || $("input[name='auction_promotion_activity[pre_price_off]']").val() < 0.01 ){
        elert('每满价格不能小于0.01,减去价格不能小于0.01')
        return false
      }
    }else if (discount_type == "3") {
      if($("input[name='auction_promotion_activity[price_more]']").val() < 0.01 || $("input[name='auction_promotion_activity[price_off]']").val() < 0.01 ){
        elert('价格不能小于0.01')
        return false
      }
    }

  })



});
