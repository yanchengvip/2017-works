//= require supplier/jquery-1.10.2
//= require supplier/jquery.metisMenu
//= require supplier/custom-scripts
//= require supplier/jquery-formatime
//= require jquery_ujs
//= require supplier/sweetalert2
//= require turbolinks
//= require select2
//= require bootstrap-sprockets
//= require moment
//= require moment/zh-cn.js
//= require bootstrap-datetimepicker
//= require supplier/product
//= require auction/fileupload/vendor/jquery.ui.widget
//= require auction/fileupload/jquery.fileupload
//= require auction/fileupload/jquery.iframe-transport
$(function(){
  $("body").on("keyup", "input", function (e) {
      // if ($(this).attr("maxlength") != null) {
      //     if ($(this).val().length > parseInt($(this).attr("maxlength"))) {
      //         $(this).val($(this).val().substr(0, parseInt($(this).attr("maxlength"))));
      //     }
      // }
      if ($(this).attr("type") == 'number') {
          $(this).val($(this).val().replace(/[^\d]/g, ''));
      }
      if ($(this).attr("type") == 'tel') {
          $(this).val($(this).val().replace(/\D/g, ''));
      }
      if ($(this).attr("type") == 'a-Z0-9') {
          $(this).val($(this).val().replace( /[^a-zA-Z0-9\-_]/g, ''));
      }
  })
    $("body").on("blur", "input", function (e) {
      // if ($(this).attr("maxlength") != null) {
      //     if ($(this).val().length > parseInt($(this).attr("maxlength"))) {
      //         $(this).val($(this).val().substr(0, parseInt($(this).attr("maxlength"))));
      //     }
      // }
      if ($(this).attr("type") == 'number') {
          $(this).val($(this).val().replace(/[^\d]/g, ''));
      }
      if ($(this).attr("type") == 'tel') {
          $(this).val($(this).val().replace(/\D/g, ''));
      }
      if ($(this).attr("type") == 'a-Z0-9') {
          $(this).val($(this).val().replace( /[^a-zA-Z0-9\-_]/g, ''));
      }
  })
})
