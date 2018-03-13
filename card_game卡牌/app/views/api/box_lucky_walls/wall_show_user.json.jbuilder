demo = [
    {user_img: 'http://admin-card.zuanliantech.com//group1/M00/00/1A/CgABPFnO55OARb3WAAAt13ipnRU159.png',
     user_name: '官君千780',
     user_phone: '15810159635',
     product_img: 'http://admin-card.zuanliantech.com//group1/M00/00/2C/CgABPFoV1neAEXngAABZNH1un58747.jpg',
     product_name: ' Fiyta/飞亚达',
     product_price: '1699',
     prize_time: '2017-12-01 15:05:02'},
    {user_img: 'http://admin-card.zuanliantech.com//group1/M00/00/1A/CgABPFnO-s6ASsW7AAAuk2DEIQo537.png',
     user_name: '司空凌浩',
     user_phone: '13810159686',
     product_img: 'http://admin-card.zuanliantech.com//group1/M00/00/29/CgABPFoMK6uAS-pMAABnUSWKC4U510.jpg',
     product_name: 'Gucci暗红色真皮浮雕logo女士钱包',
     product_price: '3999',
     prize_time: '2017-10-01 18:26:15'},
    {user_img: 'http://admin-card.zuanliantech.com//group1/M00/00/1A/CgABPFnO56uAahUzAAAw1DArHJ8609.png',
     user_name: '上官宇',
     user_phone: '13610156585',
     product_img: 'http://admin-card.zuanliantech.com//group1/M00/00/26/CgABPFoMCOGACu6YAABm-WsYwZw523.jpg',
     product_name: '东方翡翠镶18K金钻石女士戒指',
     product_price: '3699',
     prize_time: '2017-11-08 09:36:12'},

    {user_img: 'http://admin-card.zuanliantech.com//group1/M00/00/1A/CgABPFnO-s6ASsW7AAAuk2DEIQo537.png',
     user_name: '武白雪',
     user_phone: '15810155837',
     product_img: 'http://admin-card.zuanliantech.com//group1/M00/00/35/CgABPFoujIqAQ7OmAACBrpOan1Y322.jpg',
     product_name: '京东E卡经典卡50面值',
     product_price: '50',
     prize_time: '2017-10-15 17:16:15'},
    {user_img: 'http://admin-card.zuanliantech.com//group1/M00/00/1A/CgABPFnO56uAahUzAAAw1DArHJ8609.png',
     user_name: '凋残落叶',
     user_phone: '13610143254',
     product_img: 'http://admin-card.zuanliantech.com//group1/M00/00/28/CgABPFoMKnWAVKr_AAArM8ic8p8917.jpg',
     product_name: 'Ray-Ban摩登飞行员款金色反光膜爆款太阳镜',
     product_price: '919',
     prize_time: '2017-11-01 10:46:19'},


]

json.execResult true
json.execMsg '奖品墙'
json.execErrCode 200
json.execDatas do
  json.chest_records do
    if @chest_records.present?
      json.array! @chest_records.each do |cr|
        json.user_img cr.user&.head_url
        json.user_name cr.user&.nick_name
        json.user_phone cr.user&.mobile
        json.prize_img cr.chest_prize&.thumbnail #奖品图片
        json.prize_name cr.chest_prize&.name #奖品名字
        json.prize_price cr.chest_prize&.price.to_i #奖品价格
        json.prize_time cr.created_at.strftime('%Y-%m-%d %H:%M')
      end
    else
      json.array! demo.each  do |num|

        json.user_img num[:user_img]
        json.user_name num[:user_name]
        json.user_phone num[:user_phone]
        json.prize_img num[:product_img]
        json.prize_name num[:product_name]
        json.prize_price num[:product_price].to_i
        json.prize_time num[:prize_time]
      end
    end

  end
end


