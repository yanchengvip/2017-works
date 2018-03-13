$(document).on('turbolinks:load', function () {
// $(function(){
  $('#refresh_time_picker').datetimepicker({
      format: 'HH:mm',
      locale: 'zh-cn',
      defaultDate: moment('2016-06-13 10:00').format('YYYY-MM-DD HH:mm')
  })
})

$(function(){
  $('#extreme_chests_submit').on('click', function(){
    // 宝箱内容
    var item_ok = false
    if($('.content_tr').length > 0){
      item_ok = true
    }
    if(!item_ok){
      $('#extreme_chest_items_tip').popover('show')
      return false
    }else{
      $('#extreme_chest_items_tip').popover('hide')
    }
  })
})
