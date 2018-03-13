class ExchangeProductPriceLogsController < ApplicationController
  before_action :set_exchange_product_price_log, only: [:show, :edit, :update, :destroy]

  # GET /exchange_product_price_logs
  # GET /exchange_product_price_logs.json
  def index
    @exchange_product_price_logs = ExchangeProductPriceLog.all
  end

  # GET /exchange_product_price_logs/1
  # GET /exchange_product_price_logs/1.json
  def show
  end

  # GET /exchange_product_price_logs/new
  def new
    @exchange_product_price_log = ExchangeProductPriceLog.new
  end

  # GET /exchange_product_price_logs/1/edit
  def edit
  end

  # POST /exchange_product_price_logs
  # POST /exchange_product_price_logs.json
  def create
    @exchange_product_price_log = ExchangeProductPriceLog.new(exchange_product_price_log_params)

    respond_to do |format|
      if @exchange_product_price_log.save
        format.html { redirect_to @exchange_product_price_log, notice: 'Exchange product price log was successfully created.' }
        format.json { render :show, status: :created, location: @exchange_product_price_log }
      else
        format.html { render :new }
        format.json { render json: @exchange_product_price_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exchange_product_price_logs/1
  # PATCH/PUT /exchange_product_price_logs/1.json
  def update
    respond_to do |format|
      if @exchange_product_price_log.update(exchange_product_price_log_params)
        format.html { redirect_to @exchange_product_price_log, notice: 'Exchange product price log was successfully updated.' }
        format.json { render :show, status: :ok, location: @exchange_product_price_log }
      else
        format.html { render :edit }
        format.json { render json: @exchange_product_price_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exchange_product_price_logs/1
  # DELETE /exchange_product_price_logs/1.json
  def destroy
    @exchange_product_price_log.destroy
    respond_to do |format|
      format.html { redirect_to exchange_product_price_logs_url, notice: 'Exchange product price log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_product_price_log
      @exchange_product_price_log = ExchangeProductPriceLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exchange_product_price_log_params
      params.require(:exchange_product_price_log).permit(:exchange_product_id, :dealer_id, :dealer_type, :price, :time, :active)
    end
end
