class Auction::CitiesController < ApplicationController
  before_action :set_auction_city, only: [:show, :edit, :update, :destroy]

  # GET /auction/cities
  # GET /auction/cities.json
  def index
    @auction_cities = Auction::City.all
  end

  # GET /auction/cities/1
  # GET /auction/cities/1.json
  def show
  end

  # GET /auction/cities/new
  def new
    @auction_city = Auction::City.new
  end

  # GET /auction/cities/1/edit
  def edit
  end

  # POST /auction/cities
  # POST /auction/cities.json
  def create
    @auction_city = Auction::City.new(auction_city_params)

    respond_to do |format|
      if @auction_city.save
        format.html { redirect_to @auction_city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @auction_city }
      else
        format.html { render :new }
        format.json { render json: @auction_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/cities/1
  # PATCH/PUT /auction/cities/1.json
  def update
    respond_to do |format|
      if @auction_city.update(auction_city_params)
        format.html { redirect_to @auction_city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_city }
      else
        format.html { render :edit }
        format.json { render json: @auction_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/cities/1
  # DELETE /auction/cities/1.json
  def destroy
    @auction_city.destroy
    respond_to do |format|
      format.html { redirect_to auction_cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_city
      @auction_city = Auction::City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_city_params
      params.fetch(:auction_city, {})
    end
end
