$(document).on('turbolinks:load', function () {
    //上传一个缩略图方法
    $('#upload_video_url').fileupload({
        dataType: 'json',
        url: '/images/upload',
        sequentialUploads: true,
        //maxFileSize: 5000000, //5mb
        add: function (e, data) {
            var acceptFileTypes = /(\.|\/)(mp3|mp4|avi|rmvb|AVI|wma|rm|flash|mid|3GP)$/i;
            if(data.originalFiles[0]['type'].length <= 0){
                alertTX('文件格式不正确！只能上传.mp3, .mp4, .avi, .rmvb, .AVI, .wma, .rm, .flash, .mid, .3GP等文件')
                return false
            }
            if (data.originalFiles[0]['type'].length && !acceptFileTypes.test(data.originalFiles[0]['type'])) {
                alertTX('文件格式不正确！只能上传.mp3, .mp4, .avi, .rmvb, .AVI, .wma, .rm, .flash, .mid, .3GP等文件')
                return false
            }
            if (data.originalFiles[0]['size'] > 30000000) {
                alertTX('只能上传不超过30M的文件')
                return false
            }
            data.submit();

        },
        complete: function (result, textStatus, jqXHR) {
            var data = JSON.parse(result.responseText)
            $("#card_video_url").val(data.img_path)
            $("#preview_video").attr('src', data.img_url)
        }

    });


});
