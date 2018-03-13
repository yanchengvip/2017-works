$(document).on('turbolinks:load', function () {
    $('.upload_league_img').fileupload({
        dataType: 'json',
        url: '/images/upload',
        sequentialUploads: true,
        //maxFileSize: 5000000, //5mb
        add: function (e, data) {
            // console.log($(this).attr('i'))
            $('#atarget').val($(this).attr('i'))
            var acceptFileTypes = /(\.|\/)(gif|jpe?g|png)$/i;
            if(data.originalFiles[0]['type'].length <= 0){
                elert('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
                elert('图片格式不正确！只能上传jpg,png等图片')
                return false
            }
            if (data.originalFiles[0]['size'] > 100000) {
                elert('只能上传不超过100K的图片')
                return false
            }
            data.submit();
        },

        complete: function (result, textStatus, jqXHR) {
            var data = JSON.parse(result.responseText)
            // console.log($('#atarget').val())
            // console.log($("#"+$('#atarget').val()).children('.img_val')[0])
            $($("#"+$('#atarget').val()).children('.img_val')[0]).val(data.img_path)
            $($("#"+$('#atarget').val()).children('.preview_img')[0]).attr('src', data.img_url)
        }

    });


});


//form验证图片是否存在
// function validateImageForm() {
//     if ($('#headimg_url').length > 0) {
//         headimg = $('#headimg_url').val()
//         if (headimg == "" || headimg == 'undefined') {
//             elert('头像不能为空')
//             return false
//         }
//     }

// }


