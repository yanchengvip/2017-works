class Core::ConnectionsController < ApplicationController
  before_action :set_core_connection, only: [:show, :edit, :update, :destroy]

  # GET /core/connections
  # GET /core/connections.json
  def index
    @core_connections = Core::Connection.all
  end

  # GET /core/connections/1
  # GET /core/connections/1.json
  def show
  end

  # GET /core/connections/new
  def new
    @core_connection = Core::Connection.new
  end

  # GET /core/connections/1/edit
  def edit
  end

  # POST /core/connections
  # POST /core/connections.json
  def create
    @core_connection = Core::Connection.new(core_connection_params)

    respond_to do |format|
      if @core_connection.save
        format.html { redirect_to @core_connection, notice: 'Connection was successfully created.' }
        format.json { render :show, status: :created, location: @core_connection }
      else
        format.html { render :new }
        format.json { render json: @core_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/connections/1
  # PATCH/PUT /core/connections/1.json
  def update
    respond_to do |format|
      if @core_connection.update(core_connection_params)
        format.html { redirect_to @core_connection, notice: 'Connection was successfully updated.' }
        format.json { render :show, status: :ok, location: @core_connection }
      else
        format.html { render :edit }
        format.json { render json: @core_connection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/connections/1
  # DELETE /core/connections/1.json
  def destroy
    @core_connection.destroy
    respond_to do |format|
      format.html { redirect_to core_connections_url, notice: 'Connection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_connection
      @core_connection = Core::Connection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_connection_params
      params.fetch(:core_connection, {})
    end
end
