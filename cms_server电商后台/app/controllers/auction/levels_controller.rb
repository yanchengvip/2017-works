class Auction::LevelsController < ApplicationController
  before_action :set_auction_level, only: [:show, :edit, :update, :destroy]

  # GET /auction/levels
  # GET /auction/levels.json
  def index
    @auction_levels = Auction::Level.all
  end

  # GET /auction/levels/1
  # GET /auction/levels/1.json
  def show
  end

  # GET /auction/levels/new
  def new
    @auction_level = Auction::Level.new
  end

  # GET /auction/levels/1/edit
  def edit
  end

  # POST /auction/levels
  # POST /auction/levels.json
  def create
    @auction_level = Auction::Level.new(auction_level_params)

    respond_to do |format|
      if @auction_level.save
        format.html { redirect_to @auction_level, notice: 'Level was successfully created.' }
        format.json { render :show, status: :created, location: @auction_level }
      else
        format.html { render :new }
        format.json { render json: @auction_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/levels/1
  # PATCH/PUT /auction/levels/1.json
  def update
    respond_to do |format|
      if @auction_level.update(auction_level_params)
        format.html { redirect_to @auction_level, notice: 'Level was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_level }
      else
        format.html { render :edit }
        format.json { render json: @auction_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/levels/1
  # DELETE /auction/levels/1.json
  def destroy
    @auction_level.destroy
    respond_to do |format|
      format.html { redirect_to auction_levels_url, notice: 'Level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_level
      @auction_level = Auction::Level.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_level_params
      params.fetch(:auction_level, {})
    end
end
