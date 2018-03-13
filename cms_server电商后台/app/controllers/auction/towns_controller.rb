class Auction::TownsController < ApplicationController
  before_action :set_auction_town, only: [:show, :edit, :update, :destroy]

  # GET /auction/towns
  # GET /auction/towns.json
  def index
    @auction_towns = Auction::Town.all
  end

  # GET /auction/towns/1
  # GET /auction/towns/1.json
  def show
  end

  # GET /auction/towns/new
  def new
    @auction_town = Auction::Town.new
  end

  # GET /auction/towns/1/edit
  def edit
  end

  # POST /auction/towns
  # POST /auction/towns.json
  def create
    @auction_town = Auction::Town.new(auction_town_params)

    respond_to do |format|
      if @auction_town.save
        format.html { redirect_to @auction_town, notice: 'Town was successfully created.' }
        format.json { render :show, status: :created, location: @auction_town }
      else
        format.html { render :new }
        format.json { render json: @auction_town.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/towns/1
  # PATCH/PUT /auction/towns/1.json
  def update
    respond_to do |format|
      if @auction_town.update(auction_town_params)
        format.html { redirect_to @auction_town, notice: 'Town was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_town }
      else
        format.html { render :edit }
        format.json { render json: @auction_town.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/towns/1
  # DELETE /auction/towns/1.json
  def destroy
    @auction_town.destroy
    respond_to do |format|
      format.html { redirect_to auction_towns_url, notice: 'Town was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_town
      @auction_town = Auction::Town.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_town_params
      params.fetch(:auction_town, {})
    end
end
