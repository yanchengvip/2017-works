class Pay::CmbSignsController < ApplicationController
  before_action :set_pay_cmb_sign, only: [:show, :edit, :update, :destroy]

  # GET /pay/cmb_signs
  # GET /pay/cmb_signs.json
  def index
    @pay_cmb_signs = Pay::CmbSign.all
  end

  # GET /pay/cmb_signs/1
  # GET /pay/cmb_signs/1.json
  def show
  end

  # GET /pay/cmb_signs/new
  def new
    @pay_cmb_sign = Pay::CmbSign.new
  end

  # GET /pay/cmb_signs/1/edit
  def edit
  end

  # POST /pay/cmb_signs
  # POST /pay/cmb_signs.json
  def create
    @pay_cmb_sign = Pay::CmbSign.new(pay_cmb_sign_params)

    respond_to do |format|
      if @pay_cmb_sign.save
        format.html { redirect_to @pay_cmb_sign, notice: 'Cmb sign was successfully created.' }
        format.json { render :show, status: :created, location: @pay_cmb_sign }
      else
        format.html { render :new }
        format.json { render json: @pay_cmb_sign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pay/cmb_signs/1
  # PATCH/PUT /pay/cmb_signs/1.json
  def update
    respond_to do |format|
      if @pay_cmb_sign.update(pay_cmb_sign_params)
        format.html { redirect_to @pay_cmb_sign, notice: 'Cmb sign was successfully updated.' }
        format.json { render :show, status: :ok, location: @pay_cmb_sign }
      else
        format.html { render :edit }
        format.json { render json: @pay_cmb_sign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay/cmb_signs/1
  # DELETE /pay/cmb_signs/1.json
  def destroy
    @pay_cmb_sign.destroy
    respond_to do |format|
      format.html { redirect_to pay_cmb_signs_url, notice: 'Cmb sign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pay_cmb_sign
      @pay_cmb_sign = Pay::CmbSign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pay_cmb_sign_params
      params.fetch(:pay_cmb_sign, {})
    end
end
