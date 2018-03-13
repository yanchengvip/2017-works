class Auction::EventsController < ApplicationController
  before_action :set_auction_event, only: [:show, :edit, :update, :destroy, :published]
  before_action :side_menus4

  # GET /auction/events
  # GET /auction/events.json
  def index
    @bread_menu = {m1: '券种管理', m2: '券种管理', m2_url: '/auction/events', m3: '券种列表', add: '/auction/events/new', s: 'event_search'}
    @auction_events = Auction::Event.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/events/1
  # GET /auction/events/1.json
  def show
  end

  # GET /auction/events/new
  def new
    @bread_menu = {m1: '券种管理', m2: '券种管理', m2_url: '/auction/events', m3: '新增券种'}
    @auction_event = Auction::Event.new
    @auction_event_clients = Auction::Event::CLIENTS.invert.to_a
    @auction_event_is_sell = Auction::Event::ISSELL.invert.to_a
  end

  # GET /auction/events/1/edit
  def edit
    @bread_menu = {m1: '券种管理', m2: '券种管理', m2_url: '/auction/events', m3: '修改券种'}
    @auction_event_clients = Auction::Event::CLIENTS.invert.to_a
    @auction_event_is_sell = Auction::Event::ISSELL.invert.to_a
  end

  #发布
  def published
    if @auction_event.ended_at > Time.now
      if @auction_event.update(:published => true)
        flash[:success] = '发布成功'
      else
        flash[:danger] = '发布失败'
      end
    else
      flash[:danger] = '发布失败,此优惠券已过期'
    end
    redirect_to '/auction/events'
  end

  # POST /auction/events
  # POST /auction/events.json
  def create
    @auction_event = Auction::Event.new(auction_event_params)
    if @auction_event.save
      flash[:success] = '添加成功'
    else
      flash[:danger] = '添加失败'
    end
    redirect_to '/auction/events'
  end

  # PATCH/PUT /auction/events/1
  # PATCH/PUT /auction/events/1.json
  def update
    if @auction_event.update(auction_event_params)
      flash[:success] = '修改成功'
    else
      flash[:danger] = '修改失败'
    end
    redirect_to '/auction/events'
  end

  # DELETE /auction/events/1
  # DELETE /auction/events/1.json
  def destroy
    @auction_event.destroy
    respond_to do |format|
      format.html { redirect_to auction_events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_event
      @auction_event = Auction::Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_event_params
      params.require(:auction_event).permit!
      # params.fetch(:auction_event, {})
    end
end
