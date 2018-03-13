class Auction::FavoritesController < ApplicationController
  before_action :set_auction_favorite, only: [:show, :edit, :update, :destroy]

  # GET /auction/favorites
  # GET /auction/favorites.json
  def index
    @auction_favorites = Auction::Favorite.all
  end

  # GET /auction/favorites/1
  # GET /auction/favorites/1.json
  def show
  end

  # GET /auction/favorites/new
  def new
    @auction_favorite = Auction::Favorite.new
  end

  # GET /auction/favorites/1/edit
  def edit
  end

  # POST /auction/favorites
  # POST /auction/favorites.json
  def create
    @auction_favorite = Auction::Favorite.new(auction_favorite_params)

    respond_to do |format|
      if @auction_favorite.save
        format.html { redirect_to @auction_favorite, notice: 'Favorite was successfully created.' }
        format.json { render :show, status: :created, location: @auction_favorite }
      else
        format.html { render :new }
        format.json { render json: @auction_favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/favorites/1
  # PATCH/PUT /auction/favorites/1.json
  def update
    respond_to do |format|
      if @auction_favorite.update(auction_favorite_params)
        format.html { redirect_to @auction_favorite, notice: 'Favorite was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_favorite }
      else
        format.html { render :edit }
        format.json { render json: @auction_favorite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/favorites/1
  # DELETE /auction/favorites/1.json
  def destroy
    @auction_favorite.destroy
    respond_to do |format|
      format.html { redirect_to auction_favorites_url, notice: 'Favorite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_favorite
      @auction_favorite = Auction::Favorite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_favorite_params
      params.fetch(:auction_favorite, {})
    end
end
