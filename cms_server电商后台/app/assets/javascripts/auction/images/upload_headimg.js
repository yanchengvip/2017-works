$(document).on('turbolinks:load', function () {
    //上传一个头像方法
    $('#upload_headimg').fileupload({
        dataType: 'json',
        url: '/images/upload',
        sequentialUploads: true,
        //maxFileSize: 5000000, //5mb
        add: function (e, data) {
            var acceptFileTypes = /(\.|\/)(gif|jpe?g|png)$/i;
            if(data.originalFiles[0]['type'].length <= 0){
                alertTX('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
                alertTX('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (data.originalFiles[0]['size'] > 100000) {
                alertTX('只能上传不超过100K的图片')
                return false
            }
            data.submit();

        },
        complete: function (result, textStatus, jqXHR) {
            var data = JSON.parse(result.responseText)
            $("#headimg_url").val(data.img_path)
            $("#preview_headimg").attr('src', data.img_url)
        }

    });


});


//form验证图片是否存在
function validateImageForm() {
//头像验证
    if ($('#headimg_url').length > 0) {
        headimg = $('#headimg_url').val()
        if (headimg == "" || headimg == 'undefined') {
            alertTX('头像不能为空')
            return false
        }
    }

}


