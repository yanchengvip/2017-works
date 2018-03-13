class Auction::FanshipsController < ApplicationController
  before_action :set_auction_fanship, only: [:show, :edit, :update, :destroy]

  # GET /auction/fanships
  # GET /auction/fanships.json
  def index
    @auction_fanships = Auction::Fanship.all
  end

  # GET /auction/fanships/1
  # GET /auction/fanships/1.json
  def show
  end

  # GET /auction/fanships/new
  def new
    @auction_fanship = Auction::Fanship.new
  end

  # GET /auction/fanships/1/edit
  def edit
  end

  # POST /auction/fanships
  # POST /auction/fanships.json
  def create
    @auction_fanship = Auction::Fanship.new(auction_fanship_params)

    respond_to do |format|
      if @auction_fanship.save
        format.html { redirect_to @auction_fanship, notice: 'Fanship was successfully created.' }
        format.json { render :show, status: :created, location: @auction_fanship }
      else
        format.html { render :new }
        format.json { render json: @auction_fanship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/fanships/1
  # PATCH/PUT /auction/fanships/1.json
  def update
    respond_to do |format|
      if @auction_fanship.update(auction_fanship_params)
        format.html { redirect_to @auction_fanship, notice: 'Fanship was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_fanship }
      else
        format.html { render :edit }
        format.json { render json: @auction_fanship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/fanships/1
  # DELETE /auction/fanships/1.json
  def destroy
    @auction_fanship.destroy
    respond_to do |format|
      format.html { redirect_to auction_fanships_url, notice: 'Fanship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_fanship
      @auction_fanship = Auction::Fanship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_fanship_params
      params.fetch(:auction_fanship, {})
    end
end
