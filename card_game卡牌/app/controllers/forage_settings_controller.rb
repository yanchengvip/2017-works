class ForageSettingsController < ApplicationController
  before_filter :set_forage_setting, except: [:create]
  before_action :side_menus

  def set_forage
  end

  def create
    forage_setting = ForageSetting.new(forage_setting_params)
    if current_user.is_super? && forage_setting.save
      flash['success'] = '设置成功！'
    else
      flash['danger'] = '设置失败！'
    end
    return redirect_to action: params[:from]
  end

  def update
    if current_user.is_super? && @forage_setting.update(forage_setting_params)
      flash['success'] = '设置成功！'
    else
      flash['danger'] = '设置失败！'
    end
    return redirect_to action: params[:from]
  end


  private
  def forage_setting_params
    params.require(:forage_setting).permit(:base_forage, :turn_second, :turn_forage_incr, :last_turn_second, :last_turn_per_second, :last_turn_forage_incr, :max_forage)
  end

  def set_forage_setting
    @forage_setting = ForageSetting.first || ForageSetting.new
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end
end
