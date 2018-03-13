$(document).on('turbolinks:load', function () {
  $(".package_select2").select2();
  $('body').on('click', '.popover', function(){
    $(this).popover('hide')
  })
  $('.datetime_picker_recovery1').datetimepicker({
      format: 'HH:mm:ss',
      locale: 'zh-cn',
      useCurrent: false
  });
  $('.datetime_picker_recovery2').datetimepicker({
      useCurrent: false,
      format: 'HH:mm:ss',
      locale: 'zh-cn'
  });
  // $("#datetime_picker_recovery1").on("dp.change", function (e) {
  //     $('#datetime_picker_recovery2').data("DateTimePicker").minDate(e.date);
  // });
  // $("#datetime_picker_recovery2").on("dp.show", function (e) {
  //     var time = new Date("2018-01-27 09:00:00")
  //     $('#datetime_picker_recovery2').data("DateTimePicker").minDate(time);
  // });

  $('#recovery_submit').on('click', function(){
      var end_time = $("input[name='recovery[time_end]']").val()
      var date = new Date("2018-01-26 "+ end_time)
      if (date.getHours() < 10){
        elert('结束时间不能小于10点')
        return false
      }
  })

})
