class Mammon::UserCardsController < ApplicationController
  before_action :set_mammon_user_card, only: [:show, :edit, :update, :destroy]

  # GET /mammon/user_cards
  # GET /mammon/user_cards.json
  def index
    @mammon_user_cards = Mammon::UserCard.all
  end

  # GET /mammon/user_cards/1
  # GET /mammon/user_cards/1.json
  def show
  end

  # GET /mammon/user_cards/new
  def new
    @mammon_user_card = Mammon::UserCard.new
  end

  # GET /mammon/user_cards/1/edit
  def edit
  end

  # POST /mammon/user_cards
  # POST /mammon/user_cards.json
  def create
    @mammon_user_card = Mammon::UserCard.new(mammon_user_card_params)

    respond_to do |format|
      if @mammon_user_card.save
        format.html { redirect_to @mammon_user_card, notice: 'User card was successfully created.' }
        format.json { render :show, status: :created, location: @mammon_user_card }
      else
        format.html { render :new }
        format.json { render json: @mammon_user_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mammon/user_cards/1
  # PATCH/PUT /mammon/user_cards/1.json
  def update
    respond_to do |format|
      if @mammon_user_card.update(mammon_user_card_params)
        format.html { redirect_to @mammon_user_card, notice: 'User card was successfully updated.' }
        format.json { render :show, status: :ok, location: @mammon_user_card }
      else
        format.html { render :edit }
        format.json { render json: @mammon_user_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mammon/user_cards/1
  # DELETE /mammon/user_cards/1.json
  def destroy
    @mammon_user_card.destroy
    respond_to do |format|
      format.html { redirect_to mammon_user_cards_url, notice: 'User card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mammon_user_card
      @mammon_user_card = Mammon::UserCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mammon_user_card_params
      params.require(:mammon_user_card).permit(:user_id)
    end
end
