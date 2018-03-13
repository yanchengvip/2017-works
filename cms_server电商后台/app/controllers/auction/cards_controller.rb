class Auction::CardsController < ApplicationController
  before_action :set_auction_card, only: [:show, :edit, :update, :destroy]

  # GET /auction/cards
  # GET /auction/cards.json
  def index
    @auction_cards = Auction::Card.all
  end

  # GET /auction/cards/1
  # GET /auction/cards/1.json
  def show
  end

  # GET /auction/cards/new
  def new
    @auction_card = Auction::Card.new
  end

  # GET /auction/cards/1/edit
  def edit
  end

  # POST /auction/cards
  # POST /auction/cards.json
  def create
    @auction_card = Auction::Card.new(auction_card_params)

    respond_to do |format|
      if @auction_card.save
        format.html { redirect_to @auction_card, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @auction_card }
      else
        format.html { render :new }
        format.json { render json: @auction_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/cards/1
  # PATCH/PUT /auction/cards/1.json
  def update
    respond_to do |format|
      if @auction_card.update(auction_card_params)
        format.html { redirect_to @auction_card, notice: 'Card was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_card }
      else
        format.html { render :edit }
        format.json { render json: @auction_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/cards/1
  # DELETE /auction/cards/1.json
  def destroy
    @auction_card.destroy
    respond_to do |format|
      format.html { redirect_to auction_cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_card
      @auction_card = Auction::Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_card_params
      params.fetch(:auction_card, {})
    end
end
