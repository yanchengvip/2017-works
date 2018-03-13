class Supplier::ReportFormsController < Supplier::ApplicationController
  before_action :set_supplier_report_form, only: [:show, :edit, :update, :destroy]

  # GET /supplier/report_forms
  # GET /supplier/report_forms.json
  def index
    @report_forms = Supplier::ReportForm.includes(:editor).own(current_user.id).order(id: :desc).page(params[:page] || 1)
  end

  # GET /supplier/report_forms/1
  # GET /supplier/report_forms/1.json
  def show
  end

  # GET /supplier/report_forms/new
  def new
    @supplier_report_form = Supplier::ReportForm.new
  end

  # GET /supplier/report_forms/1/edit
  def edit
  end

  # POST /supplier/report_forms
  # POST /supplier/report_forms.json
  def create
    @supplier_report_form = Supplier::ReportForm.new(supplier_report_form_params)

    respond_to do |format|
      if @supplier_report_form.save
        format.html { redirect_to @supplier_report_form, notice: 'Report form was successfully created.' }
        format.json { render :show, status: :created, location: @supplier_report_form }
      else
        format.html { render :new }
        format.json { render json: @supplier_report_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplier/report_forms/1
  # PATCH/PUT /supplier/report_forms/1.json
  def update
    respond_to do |format|
      if @supplier_report_form.update(supplier_report_form_params)
        format.html { redirect_to @supplier_report_form, notice: 'Report form was successfully updated.' }
        format.json { render :show, status: :ok, location: @supplier_report_form }
      else
        format.html { render :edit }
        format.json { render json: @supplier_report_form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplier/report_forms/1
  # DELETE /supplier/report_forms/1.json
  def destroy
    @supplier_report_form.destroy
    respond_to do |format|
      format.html { redirect_to supplier_report_forms_url, notice: 'Report form was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier_report_form
      @supplier_report_form = Supplier::ReportForm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_report_form_params
      params.require(:supplier_report_form).permit(:provider_id, :date, :trade_amount, :express_amount, :other_fee, :total_amount, :status, :user_id)
    end
end
