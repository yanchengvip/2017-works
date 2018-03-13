//删除
function obj_delete_modal(obj_id,obj_name){
    $('#deleteObjModal').modal('show');
    $('#deleteObjModal').on('shown.bs.modal',function(){
        $('#del_obj_name').html(obj_name)
        $('#del_obj_id').val(obj_id)
    })

}

//上架/下架处理
function obj_shelf_modal(obj_id,obj_name,shelf_status,title_name){
    $('#ObjShelfModal').modal('show');
    $('#ObjShelfModal').on('shown.bs.modal',function(){
        $('#shelf_obj_name').html(obj_name)
        $('#shelf_obj_id').val(obj_id)
        $('#shelf_status').val(shelf_status)
        if (title_name != ''){
            $('.title_name').html(title_name)
        }
    }).on('hidden.bs.modal', function (e) {
        $('#shelf_obj_name').html('')
        $('#shelf_obj_id').val('')
        $('#shelf_status').val('')
        $('.title_name').html('')
    })




}

//排序处理
function obj_sort_modal(obj_id,obj_name,title_name){
    $('#ObjSortModal').modal('show');
    $('#ObjSortModal').on('shown.bs.modal',function(){
        $('#sort_obj_name').html(obj_name)
        $('#sort_obj_id').val(obj_id)
        if (title_name != ''){
            $('.title_name').html(title_name)
        }
    }).on('hidden.bs.modal', function (e) {
        $('#shelf_obj_name').html('')
        $('#shelf_obj_id').val('')
        $('.title_name').html('')
    })

}

//错误消息弹出框
function alertTX(msg){
    $('#alertTXObjModal').modal('show')
    $('#alertTXObjModal').on('shown.bs.modal',function(){
        $('.alertTX-content').html(msg)
    }).on('hidden.bs.modal', function (e) {
        $('.alertTX-content').html('')
    })
}

// 字符串转时间格式
function getDate(strDate) {
  var date = eval('new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
   function (a) { return parseInt(a, 10) - 1; }).match(/\d+/g) + ')');
  return date;
}
