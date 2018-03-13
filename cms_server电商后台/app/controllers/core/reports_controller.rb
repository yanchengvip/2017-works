class Core::ReportsController < ApplicationController
  before_action :set_core_report, only: [:show, :edit, :update, :destroy]

  # GET /core/reports
  # GET /core/reports.json
  def index
    @core_reports = Core::Report.all
  end

  # GET /core/reports/1
  # GET /core/reports/1.json
  def show
  end

  # GET /core/reports/new
  def new
    @core_report = Core::Report.new
  end

  # GET /core/reports/1/edit
  def edit
  end

  # POST /core/reports
  # POST /core/reports.json
  def create
    @core_report = Core::Report.new(core_report_params)

    respond_to do |format|
      if @core_report.save
        format.html { redirect_to @core_report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @core_report }
      else
        format.html { render :new }
        format.json { render json: @core_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/reports/1
  # PATCH/PUT /core/reports/1.json
  def update
    respond_to do |format|
      if @core_report.update(core_report_params)
        format.html { redirect_to @core_report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @core_report }
      else
        format.html { render :edit }
        format.json { render json: @core_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/reports/1
  # DELETE /core/reports/1.json
  def destroy
    @core_report.destroy
    respond_to do |format|
      format.html { redirect_to core_reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_report
      @core_report = Core::Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_report_params
      params.fetch(:core_report, {})
    end
end
