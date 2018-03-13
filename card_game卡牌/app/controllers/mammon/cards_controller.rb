class Mammon::CardsController < ApplicationController
  before_action :set_mammon_card, only: [:show, :edit, :update, :destroy]
  before_action :side_menus12

  # GET /mammon/cards
  # GET /mammon/cards.json
  def index
    @mammon_cards = Mammon::Card.all
  end

  # GET /mammon/cards/1
  # GET /mammon/cards/1.json
  def show
  end

  # GET /mammon/cards/new
  def new
    @mammon_card = Mammon::Card.new
  end

  # GET /mammon/cards/1/edit
  def edit
  end

  # POST /mammon/cards
  # POST /mammon/cards.json
  def create
    @mammon_card = Mammon::Card.new(mammon_card_params)

    respond_to do |format|
      if @mammon_card.save
        format.html { redirect_to @mammon_card, notice: 'Card was successfully created.' }
        format.json { render :show, status: :created, location: @mammon_card }
      else
        format.html { render :new }
        format.json { render json: @mammon_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mammon/cards/1
  # PATCH/PUT /mammon/cards/1.json
  def update
    respond_to do |format|
      if @mammon_card.update(mammon_card_params)
        format.html { redirect_to action: :index, notice: '修改成功.' }
        format.json { render :show, status: :ok, location: @mammon_card }
      else
        format.html { render :edit }
        format.json { render json: @mammon_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mammon/cards/1
  # DELETE /mammon/cards/1.json
  def destroy
    @mammon_card.destroy
    respond_to do |format|
      format.html { redirect_to mammon_cards_url, notice: 'Card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mammon_card
      @mammon_card = Mammon::Card.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mammon_card_params
      params.require(:mammon_card).permit(:percent, :effect_percent, :attack_count, :box_percent)
    end
end
