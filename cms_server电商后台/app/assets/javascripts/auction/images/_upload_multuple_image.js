$(document).on('turbolinks:load', function () {

    //上传多个图片方法
    $('#upload_images').fileupload({
        dataType: 'json',
        url: '/images/upload',
        accept: 'application/json',
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
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
                alert('图片最大为100k')
            } else {
                data.submit();
            }

        },
        complete: function (result, textStatus, jqXHR) {
            var pro_image_urls = $('#image_urls').val();
            var data = JSON.parse(result.responseText)
            if (pro_image_urls.split(',').length > 4) {
                alert('展示图最多5张')
                return
            }
            var img = $("<img class='show_upload_img'>")
                .attr('src', data.img_url)
                .attr('id', data.id)
                .on('click', function () {
                    showDeleteImgModal(data.id, data.img_url, data.img_path)
                });
            ;
            $('#preview_images').append(img)
            if (pro_image_urls == "") {
                $('#image_urls').val(data.img_path)
            } else {
                img_url = pro_image_urls + "," + data.img_path
                $('#image_urls').val(img_url)
            }

        }

    });




});

//展示删除图片modal
function showDeleteImgModal(id, img_url, img_path) {
    //flag，1=修改缩略图，2=修改展示图，3=添加展示图，flag=1，3时，id为prodcut的id,flag=2时为image的id
    $("#deletePicModal").modal('show')
    $("#deletePicModal").on('shown.bs.modal', function () {
        $('#delete_img_pre').attr('src', '')
        $('#delete_img_pre').attr('src', img_url)
        $('#delete_img_id').val(id)
        $('#delete_img_path').val(img_path)
    })
};
//确定删除图片方法
function confirmDelProtImg() {
    id = $('#delete_img_id').val();
    img_path = $('#delete_img_path').val();
    $('#' + id).remove();
    pius = $('#image_urls').val();
    img_arr = pius.split(',')
    img_arr.splice(img_arr.indexOf(img_path), 1);
    $('#image_urls').val(img_arr.join(','));
    $("#deletePicModal").modal('hide')

}
