$(document).on('turbolinks:load', function(){
// $(function(){
  $('.del_msg_record').on('click', function(){
    $('#delMsgRecordModal').modal('show')
    var this_id = $(this).attr('id')
    var msg_type = $(this).attr('data_msg_type')
    var msg_type_str = $(this).attr('data_msg_type_str')
    $('#delMsgRecordModal').on('shown.bs.modal',function(){
      $('#del_item_id').val(this_id.split('_')[2])
      $('#del_msg_type').val(msg_type)
      $('.del_msg_type_str').text(msg_type_str)
    })
  })
})

$(document).on('turbolinks:load', function(){
  $('#delete_msg_item').on('click', function(){
    var item_id = $('#del_item_id').val()
    var msg_type = $('#del_msg_type').val()
    $.ajax({
      type: "delete",
      url: '/msg_records/' + item_id,
      data: {  },
      success: function(result){
        if(result.status == 200){
          $('#delMsgRecordModal').modal('hide')
          window.location.href = "/msg_records?msg_type=" + msg_type
        }else{
          alert('删除失败')
        }
      },
      error: function(XMLHttpResponse){
        alert('删除失败')
      }
    })
  })

  $('#task_type').on('change', function(){
    var sl_val = $(this).val()
    console.log(sl_val)
    console.log(sl_val == 6)
    console.log(sl_val == '6')
    if(!!sl_val){
      $.ajax({
        type: 'get',
        url: "/task_settings/dynamic",
        data: {task_type: sl_val},
        success: function(result){
          $('#dynamic_div').html(result)
          if(sl_val != 6 && $('#for_item_div').hasClass('hide')){
            $('#for_item_div').removeClass('hide')
          }else if(sl_val == 6){
            $('#for_item_div').addClass('hide')
          }
        },
        error: function(XMLHttpResponse){
          elert('选择失败')
          window.location.reload()
        }
      })
    }
  })

})
