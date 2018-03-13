class CardBagsController < ApplicationController
  authorize_resource :class => false,:only => [:index,:show,:new,:create,:edit,:update,:destroy]
  before_action :set_card_bag
  before_action :side_menus1
  before_action :init_params_search, only: [:index]
  before_action :get_cards, only: [:new, :edit]
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  def index
    @q = CardBag.active.ransack(params[:q])
    @card_bags = @q.result.includes(:card_bag_items).page(params[:page]).per(15)
  end

  def show
    @card_bag_items = @card_bag.card_bag_items.includes(:card)
  end

  def new
    @card_bag = CardBag.new
  end

  def create
    @card_bag = CardBag.new(card_bag_params)
    begin
      ActiveRecord::Base.transaction do
        if @card_bag.save!
          @card_bag.save_card_bag_items!(params[:card_bag_items])
        end
      end
      @card_bag.clear_redis_data
      return flash_msg('success', '添加成功！', 'index')
    rescue Exception => e
      flash[:danger] = "添加失败！#{error_msg(@card_bag)}"
      return render action: :new
    end
  end

  def edit
    @card_bag_items = @card_bag.card_bag_items.to_a
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        if @card_bag.update_attributes!(card_bag_params)
          @card_bag.update_card_bag_items!(params[:card_bag_items])
        end
      end
      @card_bag.clear_redis_data
      return flash_msg('success', '修改成功！', 'index')
    rescue Exception => e
      flash['danger'] = "修改失败！#{error_msg(@card_bag)}"
      return redirect_to action: :edit, id: @card_bag.id
    end
  end

  def destroy
    if @card_bag.destroy
      return render json: {status: 200}
    end
    return render json: {status: 500}
  end

  def get_cards
    @cards = Card.select('id, name, card_type').active
  end


  private
  def card_bag_params
    params.require(:card_bag).permit(:name)
  end

  def set_card_bag
    @card_bag = CardBag.where(id: params[:id]).first if params[:id]
  end

end
