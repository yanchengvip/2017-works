class GluttonSettingsController < ApplicationController
  authorize_resource :class => false,:only => [:set_glutton,:save_gluttons]
  before_filter :set_glutton_setting, only: [:set_glutton, :save_gluttons]
  before_action :side_menus
  skip_before_action :verify_authenticity_token, only: [:save_gluttons]

  def set_glutton
    @glutton_dead_prizes = @glutton_setting&.glutton_dead_prizes.to_a
  end

  def save_gluttons
    begin
      ActiveRecord::Base.transaction do
        # GluttonSetting.save_gluttons!(glutton_setting_params, params[:round_bloods])
        glutton_setting = @glutton_setting.new_record? ? GluttonSetting.new(glutton_setting_params) : @glutton_setting
        status = glutton_setting.new_record? ? glutton_setting.save! : glutton_setting.update_attributes!(glutton_setting_params)

        if status
          glutton_setting.save_prizes_and_texts!(params[:glutton_energy_prizes], params[:glutton_texts], params[:round])
        end
      end
      GluttonSetting.clear_redis_data
      return flash_msg('success', '设置成功！', 'set_glutton')
    rescue Exception => e
      p e.to_s
      return flash_msg('danger', '设置失败！', 'set_glutton')
    end
  end

  def content_form
    render partial: 'content_form'
  end

  def prize_item
    render partial: 'prize_item'
  end

  def text_item
    render partial: 'text_item'
  end

  def destroy_prize
    begin
      glutton_energy_prize = GluttonEnergyPrize.find(params[:glutton_energy_prize_id].to_i)
      if glutton_energy_prize && glutton_energy_prize.destroy
        GluttonSetting.clear_redis_data
        return render json: {status: 200, msg: 'success'}
      end
    rescue Exception => e
      return render json: {status: 500, msg: 'error'}
    end
  end

  def destroy_text
    begin
      glutton_text = GluttonText.find(params[:glutton_text_id].to_i)
      if glutton_text && glutton_text.destroy
        GluttonSetting.clear_redis_data
        return render json: {status: 200, msg: 'success'}
      end
    rescue Exception => e
      return render json: {status: 500, msg: 'error'}
    end
  end


  private
  def glutton_setting_params
    params.permit(:appear_time, :attack_time, :attack_user_key, :round_blood, :last_blood_energy, :max_blood_energy, :restart_time, :immune_seal_ratio, :enabling_ratio, :offer_energy_percent, :appear_text, :gonna_appear_text, :zero_blood_text, :broadcast_blood, :broadcast_key, :broadcast_text)
  end

  def set_glutton_setting
    @glutton_setting = GluttonSetting.active.first || GluttonSetting.new
  end

  def side_menus
    @side_menus = Menus::SideMenus.list[:menu3]
  end
end
