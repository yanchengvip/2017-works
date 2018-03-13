class WebSettingsController < ApplicationController
  authorize_resource :class => false, :only => [:create, :update]
  before_filter :set_web_setting, except: [:create]
  before_action :side_menus

  def create
    web_setting = WebSetting.new(web_setting_params)
    if current_user.is_super? && web_setting.save
      flash['success'] = '设置成功！'
    else
      flash['danger'] = '设置失败！'
    end
    return redirect_to action: params[:from]
  end

  def update
    if current_user.is_super? && @web_setting.update_attributes!(web_setting_params)
      flash['success'] = '设置成功！'
    else
      flash['danger'] = '设置失败！'
    end
    return redirect_to action: params[:from]
  end

  # 卡牌赠送好友
  def card_give; end

  # 赛点管理
  def match_point; end

  # 赛场信息提示
  def game_tip; end

  def glutton_rule;end

  private
  def web_setting_params
    params.require(:web_setting).permit(:link_expire_hours, :expire_days, :point_show_round, :point_show_num, :point_quit_time, :round_over_tip_time, :round_over_tip_text, :keys_gt_text, :keys_lt_text, :winner_tip_time, :winner_tip_text, :self_game_glory_prize, :auto_energy_min, :glutton_rule)
  end

  def set_web_setting
    @web_setting = WebSetting.first || WebSetting.new
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end
end
