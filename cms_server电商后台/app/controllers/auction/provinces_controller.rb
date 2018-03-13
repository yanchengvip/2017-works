class Auction::ProvincesController < ApplicationController
  before_action :set_auction_province, only: [:show, :edit, :update, :destroy]

  # GET /auction/provinces
  # GET /auction/provinces.json
  def index
    @auction_provinces = Auction::Province.all
  end

  # GET /auction/provinces/1
  # GET /auction/provinces/1.json
  def show
  end

  # GET /auction/provinces/new
  def new
    @auction_province = Auction::Province.new
  end

  # GET /auction/provinces/1/edit
  def edit
  end

  # POST /auction/provinces
  # POST /auction/provinces.json
  def create
    @auction_province = Auction::Province.new(auction_province_params)

    respond_to do |format|
      if @auction_province.save
        format.html { redirect_to @auction_province, notice: 'Province was successfully created.' }
        format.json { render :show, status: :created, location: @auction_province }
      else
        format.html { render :new }
        format.json { render json: @auction_province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/provinces/1
  # PATCH/PUT /auction/provinces/1.json
  def update
    respond_to do |format|
      if @auction_province.update(auction_province_params)
        format.html { redirect_to @auction_province, notice: 'Province was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_province }
      else
        format.html { render :edit }
        format.json { render json: @auction_province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/provinces/1
  # DELETE /auction/provinces/1.json
  def destroy
    @auction_province.destroy
    respond_to do |format|
      format.html { redirect_to auction_provinces_url, notice: 'Province was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_province
      @auction_province = Auction::Province.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_province_params
      params.fetch(:auction_province, {})
    end
end
