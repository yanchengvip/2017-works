//状态修改modal
function obj_status_modal(obj_id,title_name,obj_name,obj_status,form_url){
    $('#ObjStatusModal').modal('show');
    $('#ObjStatusModal').on('shown.bs.modal',function(){
        $('#obj_name').html(obj_name)
        $('#obj_id').val(obj_id)
        $('#obj_status').val(obj_status)
        $('.title_name').html(title_name)
        $("#obj_status_form").attr("action", form_url);
    }).on('hidden.bs.modal', function (e) {
        $('#obj_name').html('')
        $('#obj_id').val('')
        $('#obj_status').val('')
        $('#obj_remark').val('')
        $('.title_name').html('')
    })

}

//状态修改modal
function obj_show_modal(){
    $('#ObjShowModal').modal('show');
    $('#ObjShowModal').on('shown.bs.modal',function(){

    }).on('hidden.bs.modal', function (e) {

    })

}