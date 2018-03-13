$(document).on('turbolinks:load', function () {
  $('#game_prop_config_type').on('change', function(){
    var sl_val = $(this).val()
    console.log(111)
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: "/game_props/get_card_form",
        data: {config_type: sl_val},
        success: function(result){
          $('#silk_bag_card_div').html(result)
        },
        error: function(XMLHttpResponse){
          elert('网络错误')
        }
      })
    }
  })

})
