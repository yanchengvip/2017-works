/**
 * Created by iuzuan on 2017/12/14.
 */


//追加兑奖码modal
function add_box_prize_code_modal(box_prize_id,num) {
    $('#AddBoxPrizeCodeModal').modal('show');
    $('#AddBoxPrizeCodeModal').on('shown.bs.modal', function () {
        $('#add_box_prize_id').val(box_prize_id)
        $('#max_num').attr('max',num)
    })
}

//一次生成兑奖码最大次数
function limit_box_prize_max_num(num){
    $('#max_num').attr('max',num)
}