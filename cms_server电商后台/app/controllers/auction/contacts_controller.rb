class Auction::ContactsController < ApplicationController
  before_action :set_auction_contact, only: [:show, :edit, :update, :destroy]
  before_action :side_menus4

  # GET /auction/contacts
  # GET /auction/contacts.json
  def index
    @bread_menu = {m1: '地址管理', m2: '收货地址管理', m2_url: '/auction/contacts', s: 'contact_search'}
    @auction_contacts = Auction::Contact.ransack(params[:q]).result.page(params[:page]).per(15)
  end

  # GET /auction/contacts/1
  # GET /auction/contacts/1.json
  def show
  end

  # GET /auction/contacts/new
  def new
    @auction_contact = Auction::Contact.new
  end

  # GET /auction/contacts/1/edit
  def edit
  end

  # POST /auction/contacts
  # POST /auction/contacts.json
  def create
    @auction_contact = Auction::Contact.new(auction_contact_params)

    respond_to do |format|
      if @auction_contact.save
        format.html { redirect_to @auction_contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @auction_contact }
      else
        format.html { render :new }
        format.json { render json: @auction_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /auction/contacts/1
  # PATCH/PUT /auction/contacts/1.json
  def update
    respond_to do |format|
      if @auction_contact.update(auction_contact_params)
        format.html { redirect_to @auction_contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @auction_contact }
      else
        format.html { render :edit }
        format.json { render json: @auction_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /auction/contacts/1
  # DELETE /auction/contacts/1.json
  def destroy
    @auction_contact.destroy
    respond_to do |format|
      format.html { redirect_to auction_contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction_contact
      @auction_contact = Auction::Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def auction_contact_params
      params.fetch(:auction_contact, {})
    end
end
