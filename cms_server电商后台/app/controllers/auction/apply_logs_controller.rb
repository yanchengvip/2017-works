class Auction::ApplyLogsController < ApplicationController
  before_action :set_auction_apply_log, only: [:show, :edit, :update, :destroy]

  # GET /auction/apply_logs
  # GET /auction/apply_logs.json
  def index
    @auction_apply_logs = Auction::ApplyLog.all
  end

  # GET /auction/apply_logs/1
  # GET /auction/apply_logs/1.json
  def show
  end

  # GET /auction/apply_logs/new
  def new
    @auction_apply_log = Auction::ApplyLog.new
  end

  # GET /auction/apply_logs/1/edit
  def edit
  end

  # POST /auction/apply_logs
  # POST /auction/apply_logs.json
  def create
    @auction_apply_log = Auction::ApplyLog.new(auction_apply_log_params)

    respond_to do |format|
      if @auction_apply_log.save
        format.html { redirect_to @auction_apply_log, notice: 'Apply log was successfully created.' }
        format.json { render :show, status: :created, location: @auction_apply_log }
      else
        format.html { render :new }
        format.json { render json: @auction_apply_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/apply_logs/1
  # PATCH/PUT /auction/apply_logs/1.json
  def update
    respond_to do |format|
      if @auction_apply_log.update(auction_apply_log_params)
        format.html { redirect_to @auction_apply_log, notice: 'Apply log was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_apply_log }
      else
        format.html { render :edit }
        format.json { render json: @auction_apply_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/apply_logs/1
  # DELETE /auction/apply_logs/1.json
  def destroy
    @auction_apply_log.destroy
    respond_to do |format|
      format.html { redirect_to auction_apply_logs_url, notice: 'Apply log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_apply_log
      @auction_apply_log = Auction::ApplyLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_apply_log_params
      params.require(:auction_apply_log).permit(:apply_id, :user_id, :active, :content, :check_result, :check_time)
    end
end
