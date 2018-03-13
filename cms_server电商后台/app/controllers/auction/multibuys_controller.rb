class Auction::MultibuysController < ApplicationController
  before_action :set_auction_multibuy, only: [:show, :edit, :update, :destroy]

  # GET /auction/multibuys
  # GET /auction/multibuys.json
  def index
    @auction_multibuys = Auction::Multibuy.all
  end

  # GET /auction/multibuys/1
  # GET /auction/multibuys/1.json
  def show
  end

  # GET /auction/multibuys/new
  def new
    @auction_multibuy = Auction::Multibuy.new
  end

  # GET /auction/multibuys/1/edit
  def edit
  end

  # POST /auction/multibuys
  # POST /auction/multibuys.json
  def create
    @auction_multibuy = Auction::Multibuy.new(auction_multibuy_params)

    respond_to do |format|
      if @auction_multibuy.save
        format.html { redirect_to @auction_multibuy, notice: 'Multibuy was successfully created.' }
        format.json { render :show, status: :created, location: @auction_multibuy }
      else
        format.html { render :new }
        format.json { render json: @auction_multibuy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/multibuys/1
  # PATCH/PUT /auction/multibuys/1.json
  def update
    respond_to do |format|
      if @auction_multibuy.update(auction_multibuy_params)
        format.html { redirect_to @auction_multibuy, notice: 'Multibuy was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_multibuy }
      else
        format.html { render :edit }
        format.json { render json: @auction_multibuy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/multibuys/1
  # DELETE /auction/multibuys/1.json
  def destroy
    @auction_multibuy.destroy
    respond_to do |format|
      format.html { redirect_to auction_multibuys_url, notice: 'Multibuy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_multibuy
      @auction_multibuy = Auction::Multibuy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_multibuy_params
      params.fetch(:auction_multibuy, {})
    end
end
