// 删除礼包分类
function package_type_delete(package_id, package_name){
  $('#deletePackageTypetModal').modal('show');
  $('#deletePackageTypetModal').on('shown.bs.modal',function(){
    $('#del_package_type_name').html(package_name)
    $('#del_package_type_id').val(package_id)
  })
}
