class SignGiftSettingsController < ApplicationController
  before_action :side_menus10
  skip_before_action :verify_authenticity_token, only: [:destroy_gift]


  def index
    @sign_gifts = SignGiftSetting.active.page(params[:page]).per(30)
  end

  def new
    @sign_gift_setting = SignGiftSetting.new
  end

  def create
    flash[:success] = '创建成功'
    sgs = SignGiftSetting.where(running_days: params[:sign_gift_setting][:running_days]).active
    if sgs.present?
      flash[:success] = '连续登陆天数不能重复'
      redirect_to sign_gift_settings_path and return
    end
    SignGiftSetting.create(set_sign_gift_params)
    redirect_to sign_gift_settings_path
  end

  def destroy_gift
    SignGiftSetting.find(params[:id]).destroy
    flash[:success] = '删除成功'
    redirect_to sign_gift_settings_path
  end


  private


  def set_sign_gift_params
    params.require(:sign_gift_setting).permit(:running_days,:remark, :amount, :gift_type,:is_main)
  end
end
