class Auction::TradesUpdatingsController < ApplicationController
  before_action :set_auction_trades_updating, only: [:show, :edit, :update, :destroy]

  # GET /auction/trades_updatings
  # GET /auction/trades_updatings.json
  def index
    @auction_trades_updatings = Auction::TradesUpdating.all
  end

  # GET /auction/trades_updatings/1
  # GET /auction/trades_updatings/1.json
  def show
  end

  # GET /auction/trades_updatings/new
  def new
    @auction_trades_updating = Auction::TradesUpdating.new
  end

  # GET /auction/trades_updatings/1/edit
  def edit
  end

  # POST /auction/trades_updatings
  # POST /auction/trades_updatings.json
  def create
    @auction_trades_updating = Auction::TradesUpdating.new(auction_trades_updating_params)

    respond_to do |format|
      if @auction_trades_updating.save
        format.html { redirect_to @auction_trades_updating, notice: 'Trades updating was successfully created.' }
        format.json { render :show, status: :created, location: @auction_trades_updating }
      else
        format.html { render :new }
        format.json { render json: @auction_trades_updating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/trades_updatings/1
  # PATCH/PUT /auction/trades_updatings/1.json
  def update
    respond_to do |format|
      if @auction_trades_updating.update(auction_trades_updating_params)
        format.html { redirect_to @auction_trades_updating, notice: 'Trades updating was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_trades_updating }
      else
        format.html { render :edit }
        format.json { render json: @auction_trades_updating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/trades_updatings/1
  # DELETE /auction/trades_updatings/1.json
  def destroy
    @auction_trades_updating.destroy
    respond_to do |format|
      format.html { redirect_to auction_trades_updatings_url, notice: 'Trades updating was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_trades_updating
      @auction_trades_updating = Auction::TradesUpdating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_trades_updating_params
      params.fetch(:auction_trades_updating, {})
    end
end
