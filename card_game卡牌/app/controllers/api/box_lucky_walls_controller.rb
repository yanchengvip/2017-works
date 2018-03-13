class Api::BoxLuckyWallsController < Api::ApplicationController
  skip_before_action :authenticate_user, only: [:index, :wall_show_user]

  def index
    page = params[:page] ||= 1
    per = 32 #每页显示数量
    prizes = Rails.cache.fetch("box_lucky_wall_records", expires_in: 60) {
      other_products = {}
      @main_product = BoxLuckyWall.where(promotion_type: 1, status: 1).active.first
      @other_products = BoxLuckyWall.where(promotion_type: 2, status: 1).active
      #主奖品
      main_products = {title: @main_product.title, name: @main_product&.name, content: @main_product&.content, price: @main_product&.price.to_i, promotion_words: @main_product&.promotion_words, image: @main_product&.image.to_s, t114: @main_product&.t114.to_s, t267: @main_product&.t267.to_s}
      #奖品墙设置的奖品
      @other_products.each do |pro|
        prize = {"#{UUIDTools::UUID.random_create().to_s}" => {name: pro.name, content: pro.content, price: pro.price.to_i, is_over: pro.is_over, promotion_words: pro.promotion_words, image: pro.image.to_s, t114: pro.t114.to_s, t267: pro.t267.to_s, sort_num: pro.sort_num}}
        other_products.merge!(prize)
      end
      #当前宝箱里面的奖品
      ChestBox::CURRENT_BOX_TYPES.each do |key|
        if chest_box = ChestBox.current(key)
          chest_box.chest_box_prizes.includes(:chest_prize).each do |cbp|
            is_over = false #true=奖品已抽完,false=奖品未抽完
            if [1, 3].include?(cbp.prize_type.to_i)
              #1，3 奖品有库存，存在被抽完的情况； 2，4 奖品不存在被抽完的情况
              left_count = chest_box.left_prize_count cbp.chest_prize.id
              is_over = true if left_count <= 0 #已抽完
            end
            #抽奖人数,只有实物显示人数
            if cbp.chest_prize&.prize_type == 1
              lottery_num = ChestRecordItem.where(chest_prize_id: cbp.chest_prize.id, chest_box_id: chest_box.id).count
            end
            prize = {"#{UUIDTools::UUID.random_create().to_s}" => {name: cbp.chest_prize&.name, content: cbp.chest_prize&.name, price: cbp.chest_prize&.price, is_over: is_over, lottery_num: lottery_num.to_i, prize_type: cbp.chest_prize&.prize_type, promotion_words: '', image: cbp.chest_prize&.thumbnail, t114: cbp.chest_prize&.t114.to_s, t267: cbp.chest_prize&.t267.to_s, sort_num: cbp.sort_num}}
            other_products.merge!(prize)
          end
        end
      end
      #sort_num排序，由大到小
      other_products = other_products.sort_by { |k, v| v[:sort_num] }.reverse.map { |x| x[1] }
      {main_products: main_products, other_products: other_products}
    }

    arr = prizes[:other_products].slice(((page.to_i - 1)*per), per)
    render json: {execResult: true, execMsg: '奖品墙', execErrCode: 200, execDatas: {main_products: prizes[:main_products], other_products: arr.present? ? arr : []}}
  end

  def wall_show_user
    @main_product = BoxLuckyWall.where(promotion_type: 1, status: 1).active.first
    num = @main_product&.lucky_user_num.present? ? @main_product&.lucky_user_num : 5
    @chest_records = ChestRecord.includes(:user, :chest_prize).where.not(big_prize_id: 0)
                         .order('created_at desc').limit(num)
  end


  #使用兑换码
  def exchange_prize_code
    begin
      bpc1 = BoxPrizeCode.includes(:box_prize).where(code: params[:code]).active.first
      if bpc1.nil?
        render json: {execResult: true, execMsg: '兑换码不存在', execErrCode: 401, execDatas: []} and return
      end
      if !bpc1.box_prize.present?
        render json: {execResult: true, execMsg: '兑换码不存在', execErrCode: 402, execDatas: []} and return
      end

      if bpc1.box_prize.valid_date.nil? || (bpc1.box_prize.valid_date.strftime("%Y-%m-%d") < Time.now.strftime("%Y-%m-%d"))
        render json: {execResult: true, execMsg: '兑换码已失效', execErrCode: 403, execDatas: []} and return
      end
      if bpc1.box_prize.status != 1
        render json: {execResult: true, execMsg: '兑换码已禁用', execErrCode: 404, execDatas: []} and return
      end
      user_prize_count = BoxPrizeRecord.where(user_id: current_user.id, box_prize_id: bpc1.box_prize.id).count()
      if user_prize_count >= bpc1.box_prize.limit_num.to_i
        render json: {execResult: true, execMsg: '使用兑换码次数已达上限', execErrCode: 405, execDatas: []} and return
      end
      res = bpc1.exchange_price_code current_user
      if res[:execErrCode] == 406
        render json: res and return
      end
    rescue Exception => e
      render json: {execResult: true, execMsg: '网络异常', execErrCode: 407, execDatas: [error: e.as_json]} and return
    end
    render json: {execResult: true, execMsg: '兑换成功', execErrCode: 200, execDatas: {ticket_num: bpc1.box_prize.treasure_amount.to_i}}
  end


end
