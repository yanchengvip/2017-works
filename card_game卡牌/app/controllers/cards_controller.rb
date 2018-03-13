class CardsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :side_menus
  before_action :set_card, except: [:index]
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:update]

  def index
    params[:q][:s] = "order_num asc, created_at DESC"
    @q = Card.active.ransack(params[:q])
    @cards = @q.result.page(params[:page]).per(15)
  end

  def show

  end

  def new
    @card = Card.new
    @images = []
  end

  def create
    # image_url_array = params[:pro_image_urls].split(',')
    # return flash_msg('danger', '卡牌修改失败，请上传展示图！', 'new') if image_url_array.blank?
    # card = Card.new(card_params)
    # if card.save
    #   image_url_array.each do |url|
    #     card.images.create(url: url)
    #   end
    #   return flash_msg('success', '添加卡牌成功！', 'index')
    # end
    # return flash_render('danger', "添加卡牌失败！#{error_msg(card)}", 'new')
  end

  def edit
    images = Image.get_image_url @card
    @img_paths = images[:img_paths]
    # @thumbnail = @card.thumbnail.present? ? (FASTDFSCONFIG[:fastdfs][:tracker_url]+@card.thumbnail) : ''
    @thumbnail = FASTDFSCONFIG[:fastdfs][:tracker_url]+@card.thumbnail&.to_s
    @thumbnail_path = @card.thumbnail
    # @order_nums = (1..Card.active.count).to_a
    @video_path = @card.video_url
    # @video_url = FASTDFSCONFIG[:fastdfs][:tracker_url] + (@card.video_url || '')
  end

  def update
    need_params = {}
    params_arr = CARDCONFIG[@card.code.to_i]['cols'] + Card::CARD_ATTR
    params_arr.each do |attr|
      need_params.merge!(card_params.slice(attr))
    end

    begin
      ActiveRecord::Base.transaction do
        @card.update_attributes!(need_params)
        Image.change_image_url @card, params[:image_urls]
      end
      @card.clear_redis_data
      # OperateLog.log(current_user, 'update', @card, '修改卡牌')
      return flash_msg('success', '修改成功！', 'index')
    rescue Exception => e
      flash[:danger] = '修改失败！'
      return redirect_to action: :edit, id: @card.id
    end
  end

  def destroy
    # @card.destroy
    # return flash_msg('success', '操作成功！', 'index')
  end

  # 礼包内容添加卡牌时获取价格
  def get_card
    if @card
      return render json: {status: 200, msg: 'success', data: {price: @card.price&.to_f}}
    end
    return render json: {status: 200, msg: 'error'}
  end

  # 卡牌排序
  def get_order_num
    if card = Card.active.where('order_num = ?', params[:num]).first
      return render json: {status: 500, msg: '排序不能重复！', data: {name: card.name}}
    end
    return render json: {status: 200, msg: 'success'}
  end


  private
  def card_params
    params.permit(:name, :price, :summary, :thumbnail, :details, :operator_id, :operator_name, :ignore_defense, :aim_range, :max_key, :use_aim, :attach_aim, :effect_condition, :effect_times, :is_disable, :disable_time, :is_confusion, :confusion_time, :is_exchange, :transfer_type, :transfer_percent, :cooldown, :order_num, :video_url, :energy, :attack_energy, :use_times, :forage, :attack_full, :attack_curr, :control_full, :control_curr, :defense_full, :defense_curr, :consume_full, :consume_curr, :cool_full, :instruction)
  end

  def set_card
    @card = Card.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end

end
