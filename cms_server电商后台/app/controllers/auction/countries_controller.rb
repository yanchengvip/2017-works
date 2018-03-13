class Auction::CountriesController < ApplicationController
  before_action :set_auction_country, only: [:show, :edit, :update, :destroy]

  # GET /auction/countries
  # GET /auction/countries.json
  def index
    @auction_countries = Auction::Country.all
  end

  # GET /auction/countries/1
  # GET /auction/countries/1.json
  def show
  end

  # GET /auction/countries/new
  def new
    @auction_country = Auction::Country.new
  end

  # GET /auction/countries/1/edit
  def edit
  end

  # POST /auction/countries
  # POST /auction/countries.json
  def create
    @auction_country = Auction::Country.new(auction_country_params)

    respond_to do |format|
      if @auction_country.save
        format.html { redirect_to @auction_country, notice: 'Country was successfully created.' }
        format.json { render :show, status: :created, location: @auction_country }
      else
        format.html { render :new }
        format.json { render json: @auction_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/countries/1
  # PATCH/PUT /auction/countries/1.json
  def update
    respond_to do |format|
      if @auction_country.update(auction_country_params)
        format.html { redirect_to @auction_country, notice: 'Country was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_country }
      else
        format.html { render :edit }
        format.json { render json: @auction_country.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/countries/1
  # DELETE /auction/countries/1.json
  def destroy
    @auction_country.destroy
    respond_to do |format|
      format.html { redirect_to auction_countries_url, notice: 'Country was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_country
      @auction_country = Auction::Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_country_params
      params.fetch(:auction_country, {})
    end
end
