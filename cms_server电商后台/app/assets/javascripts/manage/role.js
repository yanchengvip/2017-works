//全选
function choose_all_authority(){
  $("#choose_unall").prop("checked",false)
  $("[name='manage_role[authority_ids][]']").prop("checked",true)
}

//反选
function choose_unall_authority(){
  $("#choose_all").prop("checked",false)
  $("[name='manage_role[authority_ids][]']").prop("checked",false)
}
