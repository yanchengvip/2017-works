class GamesController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show]
  before_action :set_game
  before_action :side_menus1
  before_action :init_params_search, only: [:index]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = Game.active.ransack(params[:q])
    @games = @q.result.includes(:game_type).page(params[:page]).per(15)
  end

  def show
    @products = BattleProduct.select("id, sku, name").where(id: @game.product_ids&.split(','))
  end



  private
  def set_game
    @game = Game.includes(:game_type).where(id: params[:id]).first if params[:id]
  end

end
