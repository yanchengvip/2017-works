$(document).on('turbolinks:load', function () {
    //上传一个缩略图方法
    $('#upload_thumbnail').fileupload({
        dataType: 'json',
        url: '/images/upload',
        sequentialUploads: true,
        //maxFileSize: 5000000, //5mb
        add: function (e, data) {
          console.log($(this))
            var acceptFileTypes = /(\.|\/)(gif|jpe?g|png)$/i;
            if(data.originalFiles[0]['type'].length <= 0){
                alertTX('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
                alertTX('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (($(this).attr('data_for') == 'copy') && (data.originalFiles[0]['size'] > 30000)) {
                // alert($(this).attr('data_for'))
                alertTX('文案只能上传不超过30K的图片')
                return false
            }
            else if ($(this).attr('data_for') == 'glutton') {
              if (data.originalFiles[0]['size'] > 200000){
                // alert($(this).attr('data_for'))
                alertTX('只能上传不超过200K的图片')
                return false
              }
            }
            else if (($(this).attr('file_size') == '300k') && (data.originalFiles[0]['size'] > 300000)){
                alertTX('只能上传300K以内的图片')
                return false
            } else if (data.originalFiles[0]['size'] > 51200) {
                alertTX('只能上传不超过50K的图片')
                return false
            }
            data.submit();

        },
        complete: function (result, textStatus, jqXHR) {
            var data = JSON.parse(result.responseText)
            $("#thumbnail").val(data.img_path)
            $("#preview_thumbnail").attr('src', data.img_url)
        }

    });


});


//form验证图片是否存在
function validateImageForm() {
//缩略图验证
    if ($('#thumbnail').length > 0) {
        thumbnail = $('#thumbnail').val()
        if (thumbnail == "" || thumbnail == 'undefined') {
            alertTX('缩略图不能为空')
            return false
        }
    }
//展示图片验证
    if ($('#image_urls').length > 0) {
        image_urls = $('#image_urls').val()
        if (image_urls == "" || image_urls == 'undefined') {
            alertTX('展示图不能为空');
            return false
        }
    }


}


