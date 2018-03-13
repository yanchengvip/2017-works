class CardUserOwnsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update,
                                                :destroy,:user_energy,:new_give,:create_give]
  before_filter :set_card_user_own
  before_filter :side_menus
  before_action :init_params_search, only: [:index, :user_energy]
  skip_before_action :verify_authenticity_token, only: [:create, :create_give]

  def index
    @q = CardUserOwn.active.ransack(params[:q])
    @card_user_owns = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def new
  end

  def create
    mobiles = params[:mobiles].split(',')
    users = User.where(mobile: mobiles)
    return flash_msg('danger', "卡牌赠送失败，没找到对应用户，请检查手机号！", 'new') if users.blank?
    err_ids = []

    users.each do |user|
      params[:card_user_own_items].each do |item|
        res = CardUserOwn.push_data({userId: user.id, cardId: item['card_id'], num: item['card_count']})
        err_ids << user.mobile if !res[:succ]
      end
    end
    err_ids = '失败用户id：' + err_ids.flatten.join(',') if !err_ids.blank?

    if err_ids.blank?
      return flash_msg('success', "卡牌赠送完毕！", 'index')
    else
      return flash_msg('danger', "卡牌赠送完毕！#{err_ids}", 'index')
    end
  end

  def item_form
    render partial: 'item_form'
  end

  def user_energy
    @q = AccountTicket.active.ransack(params[:q])
    @account_tickets = @q.result.includes(:user).page(params[:page]).per(15)
  end

  def new_give
  end

  def create_give
    # 13522031448,18735830248
    mobiles = params[:mobiles].split(',').map(&:strip)
    users = User.select('id, mobile').where(mobile: mobiles)
    return flash_msg('danger', "能量赠送失败，没找到对应用户，请检查手机号！", 'new_give') if users.blank?
    err_ids = []

    users.each do |user|
      res = CardUserOwn.give_energy({userId: user.id, num: params[:energy_count]})
      err_ids << user.mobile if !res[:succ]
    end
    err_ids = '失败用户id：' + err_ids.flatten.join(',') if !err_ids.blank?

    if err_ids.blank?
      return flash_msg('success', "能量赠送完毕！", 'user_energy')
    else
      return flash_msg('danger', "能量赠送完毕！#{err_ids}", 'user_energy')
    end
  end



  private

  # def card_user_own_params
  #   params.require(:card_user_own).permit(:user_id, :card_id, :card_name, :card_type, :card_num, :create_time, :creator_id, :memo)
  # end

  def set_card_user_own
    @card_user_own = CardUserOwn.find(params[:id]) if params[:id]
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu5]
  end
end
