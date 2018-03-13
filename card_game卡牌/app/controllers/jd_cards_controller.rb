class JdCardsController < ApplicationController
  authorize_resource :class => false, :only => [:index, :show, :new, :create, :edit, :update, :destroy]
  before_filter :find_jd_card
  before_action :side_menus10

  def index
    @q = JdCard.ransack(params[:q])
    @jd_cards = @q.result.page(params[:page]).per(15)
  end

  def new
    @jd_card = JdCard.new
  end

  def create
    return redirect_to new_jd_card_path, notice: '导入文件不能为空！' if params[:jd_card_excel].blank?
    uploader = ExcelUploader.new()
    uploader.store!(params[:jd_card_excel])
    file_path = uploader.url
    JdCard.import_from_excel file_path
    return redirect_to jd_cards_path, notice: '导入成功！'
  end



  private
  def chest_order_params
    params.require(:jd_cards).permit!
  end

  def find_jd_card
    @jd_card = JdCard.find(params[:id]) if params[:id]
  end
end
