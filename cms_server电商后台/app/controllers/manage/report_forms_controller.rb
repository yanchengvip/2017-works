class Manage::ReportFormsController < ApplicationController
  before_action :set_manage_report_form, only: [:show, :edit, :update, :destroy, :update_status]
  before_action :side_menus5


  def index
    @bread_menu = {m1: '结算管理', m2: '结算管理', m2_url: '/manage/report_forms', m3: '结算列表',add: '/manage/report_forms/new', s: 'report_forms_search'}
    @report_forms = Manage::ReportForm.ransack(params[:q]).result.page(params[:page]).per(15)
  end


  def show
  end


  def new
    @bread_menu = {m1: '结算管理', m2: '结算管理', m2_url: '/manage/report_forms', m3: '结算列表',add: '/manage/report_forms/new', s: 'report_forms_search'}
    @manage_report_form = Manage::ReportForm.new
    @manage_report_form_status = Manage::ReportForm::STATUS.invert.to_a
  end


  def edit
    @manage_report_form_status = Manage::ReportForm::STATUS.invert.to_a
  end


  def create
    @manage_report_form = Manage::ReportForm.new(manage_report_form_params)
    if @manage_report_form.save
      flash[:success] = '创建成功'
    else
      flash[:error] = '创建失败'
    end
    redirect_to '/manage/report_forms'
  end


  def update
    if @manage_report_form.update(manage_report_form_params)
      flash[:success] = '编辑成功'
    else
      flash[:error] = '编辑失败'
    end
    redirect_to '/manage/report_forms'
  end
  #更改状态
  def update_status
    if @manage_report_form.update(:status => 1)
      flash[:success] = '成功'
    else
      flash[:error] = '失败'
    end
    redirect_to '/manage/report_forms'
  end


  def destroy
    @manage_report_form.destroy
    respond_to do |format|
      format.html { redirect_to supplier_report_forms_url, notice: 'Report form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_manage_report_form
      @manage_report_form = Manage::ReportForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manage_report_form_params
      params.require(:manage_report_form).permit!
      # params.require(:manage_report_form).permit(:provider_id, :date, :trade_amount, :express_amount, :other_fee, :total_amount, :status, :user_id)
    end
end
