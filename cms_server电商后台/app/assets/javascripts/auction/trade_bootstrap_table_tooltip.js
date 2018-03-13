// 订单列表 tooltip,解决与bootstrap-table 的hover冲突
$(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();
    $('#lst_art_adm').on('all.bs.table', function (e, name, args) {
        $('[data-toggle="tooltip"]').tooltip();
        $('[data-toggle="popover"]').popover();
    });
});