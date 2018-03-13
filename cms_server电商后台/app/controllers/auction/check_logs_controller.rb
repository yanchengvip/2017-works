class Auction::CheckLogsController < ApplicationController
  before_action :set_auction_check_log, only: [:show, :edit, :update, :destroy]

  # GET /auction_check_logs
  # GET /auction_check_logs.json
  def index
    @auction_check_logs = Auction::CheckLog.all
  end

  # GET /auction_check_logs/1
  # GET /auction_check_logs/1.json
  def show
  end

  # GET /auction_check_logs/new
  def new
    @auction_check_log = Auction::CheckLog.new
  end

  # GET /auction_check_logs/1/edit
  def edit
  end

  # POST /auction_check_logs
  # POST /auction_check_logs.json
  def create
    @auction_check_log = Auction::CheckLog.new(auction_check_log_params)

    respond_to do |format|
      if @auction_check_log.save
        format.html { redirect_to @auction_check_log, notice: 'Auction check log was successfully created.' }
        format.json { render :show, status: :created, location: @auction_check_log }
      else
        format.html { render :new }
        format.json { render json: @auction_check_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction_check_logs/1
  # PATCH/PUT /auction_check_logs/1.json
  def update
    respond_to do |format|
      if @auction_check_log.update(auction_check_log_params)
        format.html { redirect_to @auction_check_log, notice: 'Auction check log was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_check_log }
      else
        format.html { render :edit }
        format.json { render json: @auction_check_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction_check_logs/1
  # DELETE /auction_check_logs/1.json
  def destroy
    @auction_check_log.destroy
    respond_to do |format|
      format.html { redirect_to auction_check_logs_url, notice: 'Auction check log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_check_log
      @auction_check_log = Auction::CheckLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_check_log_params
      params.fetch(:auction_check_log, {})
    end
end
