class QrcodesController < ApplicationController
  before_action :side_menus3, except: [:apurl]
  skip_before_action :authenticate_user, only: [:apurl]
  skip_before_action :verify_authenticity_token, only: [:apurl, :create]

  layout false, only: [:apurl]

  def index
    # @url = request.url + '/download'
    @url = request.url + '/apurl'
    Rails.logger.info('++++++++++++++++----'+@url)
    @qrcodes = Qrcode.active.page(params[:page].to_i).per(20)
  end

  def show

  end

  def new

  end


  def create
    flash[:success] = '添加失败！'
    q = Qrcode.new(qrcode_params)
    if q.save
      flash[:success] = '添加成功！'
    end
    redirect_to '/qrcodes'
  end

  def download
    begin
      q = Qrcode.find(params[:qrcode_id])
      q.number += 1
      q.save
    rescue Exception => e
      nil
    end

    redirect_to SYSTEMCONFIG['app_download_url']
  end

  def apurl
    begin
      q = Qrcode.find(params[:qrcode_id])
      q.number += 1
      q.save
    rescue Exception => e
      nil
    end

    redirect_to SYSTEMCONFIG['app_download_url']
  end

  private

  def qrcode_params
    params.permit(:name, :number)
  end
end
