$(document).on('turbolinks:load', function () {
  $('#mail_submit').on('click', function(){
    var amt = $('#auction_mail_title').val()
    if($.trim(amt)==''){
      elert('标题不能为空')
      return false
    }
  })

  $('#auction_seckill_submit').on('click', function(){
    var asd = getDate($('#auction_seckill_date').val())
    var now = new Date()
    if(asd < now){
      elert('秒杀日期不能小于当前日期')
      return false
    }
  })

  $('#auction_pic_ad_submit').on('click', function(){
    var apap = $('#auction_pic_ad_pic').val()
    var link_url = $("#auction_pic_ad_link_url").val()
    var link_type = $("#auction_pic_ad_link_type").val()
    if(apap == ''){
      elert('没有上传图片')
      return false
    }
    if (link_type == 1) {
      if(!/^[0-9]*$/.test(link_url)){
        elert('请输入正确的专题id值')
        return false
      }
    }else if (link_type == 2) {
      if(!/^[0-9]*$/.test(link_url)){
        elert('请输入正确的商品id值')
        return false
      }
    }
  })

})
