$(document).on('turbolinks:load', function () {

    $('#accountdate').datetimepicker({
        format: 'YYYY-MM',
        locale: 'zh-cn'
    });

    $('#cashiersdate').datetimepicker({
      format: 'YYYY-MM-DD HH:mm:ss',
      minDate: moment().format('YYYY-MM-DD HH:mm'),
      locale: 'zh-cn'
    });

    $('#datetimepicker1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn'
    });
    $('#datetimepicker2').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn',
        useCurrent: false
    });
    $("#datetimepicker1").on("dp.change", function (e) {
        $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
    });
    $("#datetimepicker2").on("dp.change", function (e) {
        $('#datetimepicker1').data("DateTimePicker").maxDate(e.date);
    });


    $('#activitydeclardatetimepicker1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn'
    });
    $('#activitydeclardatetimepicker2').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn',
        useCurrent: false
    });

    $("#activitydeclardatetimepicker1").on("dp.change", function (e) {
        $('#activitydeclardatetimepicker2').data("DateTimePicker").minDate(e.date);
    });
    $("#activitydeclardatetimepicker2").on("dp.change", function (e) {
        $('#activitydeclardatetimepicker1').data("DateTimePicker").maxDate(e.date);
        var tomorrow = new Date($("#activitydeclardatetimepicker2").val());
        var date = new Date(tomorrow.getTime() + 24 * 60 * 60 * 1000)
        $('#activitydatetimepicker1').data("DateTimePicker").minDate(date);
    });



    $('#activitydatetimepicker1').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn',
        useCurrent: false
    });
    $('#activitydatetimepicker2').datetimepicker({
        format: 'YYYY-MM-DD HH:mm:ss',
        minDate: moment().format('YYYY-MM-DD HH:mm'),
        locale: 'zh-cn',
        useCurrent: false
    });
    $("#activitydatetimepicker1").on("dp.show", function (e) {
      var tomorrow = new Date($("#activitydeclardatetimepicker2").val());
      var date = new Date(tomorrow.getTime() + 24 * 60 * 60 * 1000)
      $('#activitydatetimepicker1').data("DateTimePicker").minDate(date);
    });
    $("#activitydatetimepicker2").on("dp.show", function (e) {
      var tomorrow = new Date($("#activitydatetimepicker1").val());
      var date = new Date(tomorrow.getTime() + 24 * 60 * 60 * 1000)
      $('#activitydatetimepicker2').data("DateTimePicker").minDate(date);
    });
    $("#activitydatetimepicker1").on("dp.change", function (e) {
        $('#activitydatetimepicker2').data("DateTimePicker").minDate(e.date);
    });
    $("#activitydatetimepicker2").on("dp.change", function (e) {
        $('#activitydatetimepicker1').data("DateTimePicker").maxDate(e.date);
    });


    $('.search_date').datetimepicker({
        format: 'YYYY-MM-DD',

        locale: 'zh-cn'
    }).on('dp.change', function (ev) {
        $('.search_date').val(moment(ev.date).format('YYYY-MM-DD'))
    });
    $('.search_end_date').datetimepicker({
        format: 'YYYY-MM-DD',

        locale: 'zh-cn'
    }).on('dp.change', function (ev) {
        $('.search_end_date').val(moment(ev.date).format('YYYY-MM-DD'))
    });


    $('.trade_search_dt6').datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
    });
    $('.trade_search_dt7').datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
        useCurrent: false //Important! See issue #1075
    });
    $(".trade_search_dt6").on("dp.change", function (e) {
        $('.trade_search_dt7').data("DateTimePicker").minDate(e.date);
    });
    $(".trade_search_dt7").on("dp.change", function (e) {
        $('.trade_search_dt6').data("DateTimePicker").maxDate(e.date);
    });

    $('.trade_search_dt8').datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
    });
    $('.trade_search_dt9').datetimepicker({
        format: 'YYYY-MM-DD HH:mm',
        locale: 'zh-cn',
        useCurrent: false //Important! See issue #1075
    });
    $(".trade_search_dt8").on("dp.change", function (e) {
        $('.trade_search_dt9').data("DateTimePicker").minDate(e.date);
    });
    $(".trade_search_dt9").on("dp.change", function (e) {
        $('.trade_search_dt8').data("DateTimePicker").maxDate(e.date);
    });
})
