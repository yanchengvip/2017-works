class Auction::ValuesController < ApplicationController
  before_action :set_auction_value, only: [:show, :edit, :update, :destroy]

  # GET /auction/values
  # GET /auction/values.json
  def index
    @auction_values = Auction::Value.all
  end

  # GET /auction/values/1
  # GET /auction/values/1.json
  def show
  end

  # GET /auction/values/new
  def new
    @auction_value = Auction::Value.new
  end

  # GET /auction/values/1/edit
  def edit
  end

  # POST /auction/values
  # POST /auction/values.json
  def create
    @auction_value = Auction::Value.new(auction_value_params)

    respond_to do |format|
      if @auction_value.save
        format.html { redirect_to @auction_value, notice: 'Value was successfully created.' }
        format.json { render :show, status: :created, location: @auction_value }
      else
        format.html { render :new }
        format.json { render json: @auction_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/values/1
  # PATCH/PUT /auction/values/1.json
  def update
    respond_to do |format|
      if @auction_value.update(auction_value_params)
        format.html { redirect_to @auction_value, notice: 'Value was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_value }
      else
        format.html { render :edit }
        format.json { render json: @auction_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/values/1
  # DELETE /auction/values/1.json
  def destroy
    @auction_value.destroy
    respond_to do |format|
      format.html { redirect_to auction_values_url, notice: 'Value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_value
      @auction_value = Auction::Value.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_value_params
      params.fetch(:auction_value, {})
    end
end
