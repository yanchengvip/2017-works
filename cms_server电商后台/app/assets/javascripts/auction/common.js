$(document).on('turbolinks:load', function () {
  $(".is_select2").select2()

  $('.is_date').datetimepicker({
      format: 'YYYY-MM-DD',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $(this).val(moment(ev.date).format('YYYY-MM-DD'))
  });

  $('.is_date2').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $(this).val(moment(ev.date).format('YYYY-MM-DD HH:mm:ss'))
  });

  $('.is_year').datetimepicker({
      format: 'YYYY',
      locale: 'zh-cn'
  }).on('dp.change',function (ev) {
      $('.is_year').val(moment(ev.date).format('YYYY'))
  });

  $('body').on('click', '.del_item_new', function(){
    $(this).parent().parent().remove()
  })

  $('#q_date_gteq').datetimepicker({
      format: 'YYYY-MM-DD',
      locale: 'zh-cn'
  })
  $('#q_created_at_gteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  })
  $('#q_created_at_lteq').datetimepicker({
      format: 'YYYY-MM-DD HH:mm',
      locale: 'zh-cn'
  })

  $('img.list').on('error', function(){
    // $(this).attr('src', '/assets/no_pic.png')
    // $(this).css('max-width', '150px').css('max-height', '200px')
    // $(this).attr('onerror', null)
    $(this).css('display','none')
  })

})

function elert(msg){
  $('#ErroralertModal').modal('show')
  $('#ErroralertModal').on('shown.bs.modal',function(){
      $('.error-content').html(msg)
  }).on('hidden.bs.modal', function (e) {
      $('.error-content').html('')
  })
}

function getDate(strDate) {
  var date = eval('new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
   function (a) { return parseInt(a, 10) - 1; }).match(/\d+/g) + ')');
  return date;
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
